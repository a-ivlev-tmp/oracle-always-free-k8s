variable "compartment_id" { type = string }
variable "ssh_key_pub_path" { type = string }
variable "load_balancer_id" { type = string }

variable "leader" {
  type = object({
    shape = string
    image = object({
      operating_system         = string
      operating_system_version = string
    })
    ocpus            = number
    memory_in_gbs    = number
    hostname         = string
    subnet_id        = string
    assign_public_ip = bool
  })
}

variable "workers" {
  description = "List of worker-specific configurations"
  type = list(object({
    name          = string
    shape         = string
    ocpus         = number
    memory_in_gbs = number
  }))
}

variable "workers_shared_conf" {
  description = "Common configuration for all workers"
  type = object({
    image = object({
      operating_system         = string
      operating_system_version = string
    })
    subnet_id                = string
    assign_public_ip         = bool
    shape                    = string
  })
}

variable "availability_domain" {
  type    = number
  default = 0
}
