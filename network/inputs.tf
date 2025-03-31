variable "compartment_id" { type = string }
variable "region" { type = string }

variable "vcn_dns_label" {
  type    = string
  default = "vcn"
}

variable "public_subnet_dns_label" {
  type    = string
  default = "public"
}

variable "provision_private_subnet" { type = bool }
variable "private_subnet_dns_label" {
  type    = string
  default = "private"
}

variable "tcp_ingress_rules" {
  description = "Map of TCP ingress rules for the public security list"
  type = map(object({
    port = number
    desc = string
  }))
  default = {}
}

variable "icmp_ingress_rules" {
  description = "Map of ICMP ingress rules for the public security list"
  type = map(object({
    cidr_block = string
    desc = string
  }))
  default = {}
}

variable "udp_ingress_rules" {
  description = "Map of UDP ingress rules for the public security list"
  type = map(object({
    port = number
    desc = string
  }))
  default = {}
}

# Private subnet security rules
variable "private_tcp_ingress_rules" {
  description = "Map of TCP ingress rules for the private security list (single port)"
  type = map(object({
    port   = number
    source = string
    desc   = string
  }))
  default = {}
}

variable "private_tcp_range_rules" {
  description = "Map of TCP ingress rules for the private security list (port range)"
  type = map(object({
    min_port = number
    max_port = number
    source   = string
    desc     = string
  }))
  default = {}
}

variable "private_icmp_ingress_rules" {
  description = "Map of ICMP ingress rules for the private security list"
  type = map(object({
    source = string
    desc   = string
    type   = number
    code   = optional(number)
  }))
  default = {}
}

variable "private_udp_ingress_rules" {
  description = "Map of UDP ingress rules for the private security list"
  type = map(object({
    port   = number
    source = string
    desc   = string
  }))
  default = {}
}