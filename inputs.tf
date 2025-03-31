variable "tenancy_ocid" { type = string }
variable "region" { type = string }
variable "user_ocid" { type = string }
variable "fingerprint" { type = string }

variable "private_key_path" { type = string }
variable "private_key_password" {
  type    = string
  default = ""
}

variable "ssh_key_path" { type = string }
variable "ssh_key_pub_path" { type = string }

variable "cluster_public_dns_name" {
  type    = string
  default = null
}
variable "letsencrypt_registration_email" { type = string }

variable "windows_overwrite_local_kube_config" {
  type    = bool
  default = false
}

variable "debug_create_cluster_admin" {
  type    = bool
  default = false
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
    desc       = string
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

variable "availability_domain" {
  type        = number
  description = "Availability domain for the cluster"
}
