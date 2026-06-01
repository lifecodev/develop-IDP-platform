resource "random_password" "lxc_pass" {
  for_each = local.infra_apps
  length   = 16
  special  = true
}

resource "proxmox_virtual_environment_container" "apps_lxc" {
  for_each  = local.infra_apps
  node_name = "pve"
  vm_id     = index(keys(local.infra_apps), each.key) + 600

  initialization {
    hostname = each.key
    ip_config {
      ipv4 {
        address = "${each.value.ip}/24"
        gateway = "172.16.10.1"
      }
    }
    user_account {
      password = random_password.lxc_pass[each.key].result
      keys     = [trimspace(tls_private_key.ansible_ssh_key.public_key_openssh), var.ssh_public_key]
    }
  }
  
  network_interface {
    name   = "eth0"
    bridge = "vmbr2"
  }

  operating_system {
    template_file_id = "local:vztmpl/ubuntu-24.10-standard_24.10-1_amd64.tar.zst"
    type             = "ubuntu"
  }

  memory {
    dedicated = each.value.mem
  }

  disk {
    datastore_id = "local-lvm"
    size         = each.value.disk
  }

  unprivileged = !each.value.priv
  features {
    nesting = true
  }
}

resource "local_file" "passwords_file" {
  content  = yamlencode({
    for k, v in random_password.lxc_pass : k => {
      user     = "root"
      password = v.result
      ip       = local.infra_apps[k].ip
    }
  })
  filename = "${path.module}/access_list.yaml"
}

resource "local_file" "ansible_private_key" {
  filename = "${path.module}/id_rsa"
  content  = tls_private_key.ansible_ssh_key.private_key_pem
}