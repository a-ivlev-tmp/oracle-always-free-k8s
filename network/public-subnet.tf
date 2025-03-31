resource "oci_core_subnet" "public" {
  compartment_id    = var.compartment_id
  vcn_id            = module.vcn.vcn_id
  cidr_block        = "10.0.0.0/24"
  route_table_id    = module.vcn.ig_route_id
  security_list_ids = [oci_core_security_list.public.id]
  display_name      = "public-subnet"
  dns_label         = var.public_subnet_dns_label
}

resource "oci_core_security_list" "public" {
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  display_name   = "Security List for Public subnet"
  # Default rules
  egress_security_rules {
    stateless        = false
    destination      = "0.0.0.0/0" # internet
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }

  # TCP rules
  dynamic "ingress_security_rules" {
    for_each = var.tcp_ingress_rules
    content {
      description = ingress_security_rules.value.desc
      stateless   = false
      source      = "0.0.0.0/0" # internet
      source_type = "CIDR_BLOCK"
      protocol    = local.protocol.TCP
      tcp_options {
        min = ingress_security_rules.value.port
        max = ingress_security_rules.value.port
      }
    }
  }

  # ICMP rules
  dynamic "ingress_security_rules" {
    for_each = var.icmp_ingress_rules
    content {
      description = "ICMP traffic from ${ingress_security_rules.value.desc} network"
      stateless   = false
      source      = ingress_security_rules.value.cidr_block
      source_type = "CIDR_BLOCK"
      protocol    = local.protocol.ICMP
      # For ICMP type and code see: https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xhtml
      icmp_options {
        type = 3
        code = 4
      }
    }
  }

  # UDP 
  dynamic "ingress_security_rules" {
    for_each = var.udp_ingress_rules
    content {
      description = ingress_security_rules.value.desc
      stateless   = false
      source      = "10.0.0.0/16" # vcn
      source_type = "CIDR_BLOCK"
      protocol    = local.protocol.UDP
      udp_options {
        min = ingress_security_rules.value.port
        max = ingress_security_rules.value.port
      }
    }
  }
}
