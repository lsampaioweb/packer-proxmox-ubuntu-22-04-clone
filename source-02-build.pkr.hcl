source "proxmox-clone" "template" {
  # https://www.packer.io/plugins/builders/proxmox/clone

  # Proxmox authentication
  proxmox_url              = var.proxmox_url
  username                 = var.username
  token                    = var.token
  password                 = var.password
  insecure_skip_tls_verify = var.insecure_skip_tls_verify
  task_timeout             = var.task_timeout

  # Clone
  clone_vm   = var.clone_vm
  full_clone = var.full_clone

  # General
  node                 = var.node
  vm_id                = var.vm_id
  vm_name              = var.vm_name
  pool                 = var.pool
  template_description = var.template_description

  # Behavior
  onboot      = var.onboot
  boot        = var.boot
  disable_kvm = var.disable_kvm

  # OS
  os = var.os
  vga {
    type   = var.vga != null ? var.vga.type : null
    memory = var.vga != null ? var.vga.memory : null
  }

  # Cloud-Init
  cloud_init           = var.cloud_init
  cloud_init_disk_type = var.cloud_init_disk_type
  # Only this one comes from local, not var.
  cloud_init_storage_pool = local.cloud_init_storage_pool

  # System
  machine         = var.machine
  qemu_agent      = var.qemu_agent
  scsi_controller = var.scsi_controller

  # CPU
  sockets  = var.sockets
  cores    = var.cores
  cpu_type = var.cpu_type

  # Memory
  memory             = var.memory
  ballooning_minimum = var.ballooning_minimum

  # Hard Disk
  dynamic "disks" {
    for_each = var.disks

    content {
      storage_pool = lookup(disks.value, "storage_pool", var.disk_default_storage_pool)
      type         = lookup(disks.value, "type", var.disk_default_type)
      format       = lookup(disks.value, "format", var.disk_default_format)
      disk_size    = lookup(disks.value, "disk_size", var.disk_default_disk_size)
      cache_mode   = lookup(disks.value, "cache_mode", var.disk_default_cache_mode)
      io_thread    = lookup(disks.value, "io_thread", var.disk_default_io_thread)
      discard      = lookup(disks.value, "discard", var.disk_default_discard)
      ssd          = lookup(disks.value, "ssd", var.disk_default_ssd)
    }
  }

  # Networks
  dynamic "network_adapters" {
    for_each = var.network_adapters

    content {
      bridge   = lookup(network_adapters.value, "bridge", var.network_default_bridge)
      model    = lookup(network_adapters.value, "model", var.network_default_model)
      vlan_tag = lookup(network_adapters.value, "vlan_tag", var.network_default_vlan_tag)
      firewall = lookup(network_adapters.value, "firewall", var.network_default_firewall)
    }
  }

  # SSH
  ssh_username         = var.ssh_username
  ssh_private_key_file = var.ssh_private_key_file
  ssh_timeout          = var.ssh_timeout
}

build {
  name = "build"

  sources = ["source.proxmox-clone.template"]

  provisioner "ansible" {
    playbook_file = "${local.path_ansible_scripts}/template.yml"
    user          = var.ssh_username
    use_proxy     = var.use_proxy

    ansible_env_vars = ["ANSIBLE_CONFIG=${local.path_ansible_scripts}/ansible.cfg"]

    extra_arguments = [
      "--extra-vars",
      "hostname='${var.vm_name}'"
    ]
  }
}
