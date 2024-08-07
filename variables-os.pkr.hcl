variable "boot" {
  description = "The boot order for the VM. Ordered string of characters denoting boot order. Options: floppy (a), hard disk (c), CD-ROM (d), or network (n)."
  type        = string
  default     = "order=scsi0;net0"
}

variable "os" {
  description = "The operating system. Can be wxp, w2k, w2k3, w2k8, wvista, win7, win8, win10, l24 (Linux 2.4), l26 (Linux 2.6+), solaris or other. Defaults to other."
  type        = string
  default     = "l26"
}

variable "vga" {
  description = "The graphics adapter to use. Can be cirrus, none, qxl, qxl2, qxl3, qxl4, serial0, serial1, serial2, serial3, std, virtio, vmware. Defaults to std."
  type = object({
    type   = string,
    memory = number
    }
  )

  default = {
    type   = null,
    memory = null
  }
}
