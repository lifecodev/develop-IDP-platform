resource "proxmox_virtual_environment_vm" "k8s" {
  for_each  = local.virtual_machines
  name      = each.key
  node_name = "pve"
  
  # 1. Обязательно указываем ID твоего шаблона для клонирования
  clone {
    vm_id = 9001
  }

  cpu { cores = each.value.vcpu }
  memory { 
    dedicated = each.value.mem 
    floating  = 2048
  }

  agent { enabled = true }

  network_device { bridge = "vmbr2" }

  # 2. Переопределяем размер диска, если базового размера шаблона не хватает
  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = each.value.disk  # Автоматический resize до нужного значения
  }

  # 3. Добавляем Cloud-Init диск, чтобы Proxmox знал, куда зашивать сетевые настройки
  # (В bpg-провайдере для клонов из Cloud-Init шаблонов это частая необходимость)
  initialization {
    ip_config {
      ipv4 {
        address = "${each.value.ip}/24"
        gateway = "172.16.10.1"
      }
    }
    user_account {
      keys = [trimspace(tls_private_key.ansible_ssh_key.public_key_openssh),var.ssh_public_key]
    }
  }
}