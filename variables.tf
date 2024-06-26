variable "type" {
  type        = string
  description = "Network type 'routed' or 'internal'"
  default     = "routed"
}

variable "vcd_group_name" {
  type        = string
  description = "The name of the vdc group"
  default     = ""
}

variable "vcd_edge_name" {
  type        = string
  description = "The name of the edge gateway"
}

variable "net_name" {
  type        = string
  description = "A unique name for the network"
}

variable "prefix" {
  type        = string
  description = "The prefix netmask for the new network"
  default     = "24" 
}

variable "gw_ip" {
  type        = string
  description = "The gateway for this network"
}

variable "interface_type" {
  type        = string
  description = "An interface for the network. One of 'internal', 'subinterface', 'distributed' (requires the edge gateway to support distributed networks)"
  default     = "subinterface"
}

variable "static_pools" {
  type        = list(object({
    start_address = string
    end_address   = string
  }))
  description = "(Optional) A range of IPs permitted to be used as static IPs for virtual machines"
  default     = []
}

variable "dns_settings" {
  type        = object({
    dns1 = string
    dns2 = string
    suff = string
  })
  description = "Common DNS settings"
}

variable "dcg" {
  type = bool
  default = false
}

locals {
  cidr          = "${var.gw_ip}/${var.prefix}"
  netmask       = cidrnetmask(local.cidr)
}
