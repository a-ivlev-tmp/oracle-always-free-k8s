module "compartment" {
  source       = "./compartment"
  tenancy_ocid = var.tenancy_ocid
  compartment = {
    name        = "terraformed"
    description = "Compartment for Terraform'ed resources"
  }
}

module "network" {
  source                   = "./network"
  compartment_id           = module.compartment.id
  region                   = var.region
  vcn_dns_label            = "vcn"
  public_subnet_dns_label  = "public"
  provision_private_subnet = false
  tcp_ingress_rules        = var.tcp_ingress_rules
  icmp_ingress_rules       = var.icmp_ingress_rules
  udp_ingress_rules        = var.udp_ingress_rules
}

module "compute" {
  source              = "./compute"
  compartment_id      = module.compartment.id
  ssh_key_pub_path    = var.ssh_key_pub_path
  load_balancer_id    = module.network.load_balancer_id
  availability_domain = var.availability_domain

  leader = {
    shape = "VM.Standard.A1.Flex"
    image = {
      operating_system         = "Canonical Ubuntu"
      operating_system_version = "24.04"
    }
    ocpus            = 1
    memory_in_gbs    = 3
    hostname         = "leader-ld"
    subnet_id        = module.network.public_subnet_id
    assign_public_ip = true
  }
  workers = {
    count = 3
    shape = "VM.Standard.A1.Flex"
    image = {
      operating_system         = "Canonical Ubuntu"
      operating_system_version = "24.04"
    }
    ocpus            = 1
    memory_in_gbs    = 7
    base_hostname    = "worker-ld"
    subnet_id        = module.network.public_subnet_id
    assign_public_ip = true
  }
}

module "k8s" {
  source                              = "./k8s"
  ssh_key_path                        = var.ssh_key_path
  cluster_public_ip                   = module.network.reserved_public_ip.ip_address
  cluster_public_dns_name             = var.cluster_public_dns_name
  load_balancer_id                    = module.network.load_balancer_id
  leader                              = module.compute.leader
  workers                             = module.compute.workers
  windows_overwrite_local_kube_config = var.windows_overwrite_local_kube_config
}

module "k8s_scaffold" {
  source                         = "./k8s-scaffold"
  depends_on                     = [module.k8s]
  ssh_key_path                   = var.ssh_key_path
  cluster_public_ip              = module.network.reserved_public_ip.ip_address
  cluster_public_dns_name        = var.cluster_public_dns_name
  letsencrypt_registration_email = var.letsencrypt_registration_email
  load_balancer_id               = module.network.load_balancer_id
  leader                         = module.compute.leader
  workers                        = module.compute.workers
  debug_create_cluster_admin     = var.debug_create_cluster_admin
}

# module "k8s_helm" {
#   source     = "./k8s-helm"
#   depends_on = [module.k8s_scaffold]
# }
