variable "build_name" {
  description = "The name of the build."
  type        = string
  default     = "ubuntu"
}

variable "node" {
  description = "The node in the Proxmox cluster to create the template."
  type        = string
  default     = "kvm-07"
}

variable "vm_id" {
  description = "The ID used to reference the virtual machine. This will also be the ID of the final template. If not given, the next free ID on the node will be used."
  type        = number
}

variable "vm_name" {
  description = "Name of the virtual machine during creation. If not given, a isotime will be used."
  type        = string
}

variable "pool" {
  description = "Name of resource pool to create virtual machine in."
  type        = string
  default     = "Template"
}

variable "bios" {
  description = "The BIOS to use, options are seabios or ovmf for UEFI."
  type        = string
  default     = "seabios"
}

variable "onboot" {
  description = "Specifies whether a VM will be started during system bootup. Defaults to true."
  type        = bool
  default     = true
}

variable "task_timeout" {
  description = "The timeout for Promox API operations, e.g. clones. Defaults to 1 minute."
  type        = string
  default     = "20m"
}

variable "template_description" {
  description = "Description of the template, visible in the Proxmox interface."
  type        = string
  default     = "Ubuntu 22.04 template generated by Packer on {{ isotime `2006-01-02` }}."
}
