locals {
  infra_apps = {
    "vault"     = { ip = "172.16.30.1", mem = 1024, disk = 10, priv = false }
    "gitlab"    = { ip = "172.16.30.2", mem = 4096, disk = 60, priv = false }
    "backstage" = { ip = "172.16.30.3", mem = 2048, disk = 20, priv = false }
    "ansible"   = { ip = "172.16.30.5", mem = 512,  disk = 10, priv = false }
  }
  
  virtual_machines = {
    "k8s-master" = { 
      ip   = "172.16.100.1"
      vcpu = 2
      mem  = 4096
      disk = 30 
    }
    "k8s-worker1" = { 
      ip   = "172.16.100.2"
      vcpu = 2
      mem  = 3072
      disk = 30 
    }
    "k8s-worker2" = { 
      ip   = "172.16.100.3"
      vcpu = 2
      mem  = 3072
      disk = 30 
    }
    "gitlab-runner" = { 
      ip   = "172.16.100.4"
      vcpu = 2
      mem  = 2048
      disk = 40 
    }
  }
}