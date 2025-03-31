resource "oci_core_subnet" "private" {
  count             = var.provision_private_subnet ? 1 : 0
  compartment_id    = var.compartment_id
  vcn_id            = module.vcn.vcn_id
  cidr_block        = "10.0.1.0/24"
  route_table_id    = module.vcn.nat_route_id
  security_list_ids = [oci_core_security_list.private[0].id]
  display_name      = "private-subnet"
  dns_label         = var.private_subnet_dns_label
}

resource "oci_core_security_list" "private" {
  count          = var.provision_private_subnet ? 1 : 0
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  display_name   = "Security List for Private subnet"

  # Default rules
  egress_security_rules {
    stateless        = false
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }

  # TCP single port rules
  dynamic "ingress_security_rules" {
    for_each = var.private_tcp_ingress_rules
    content {
      description = ingress_security_rules.value.desc
      stateless   = false
      source      = ingress_security_rules.value.source
      source_type = "CIDR_BLOCK"
      protocol    = local.protocol.TTCP
      tcp_options {
        min = ingress_security_rules.value.port
        max = ingress_security_rules.value.port
      }
    }
  }

  # TCP port range rules
  dynamic "ingress_security_rules" {
    for_each = var.private_tcp_range_rules
    content {
      description = ingress_security_rules.value.desc
      stateless   = false
      source      = ingress_security_rules.value.source
      source_type = "CIDR_BLOCK"
      protocol    = local.protocol.TCP
      tcp_options {
        min = ingress_security_rules.value.min_port
        max = ingress_security_rules.value.max_port
      }
    }
  }

  # ICMP rules
  dynamic "ingress_security_rules" {
    for_each = var.private_icmp_ingress_rules
    content {
      description = "ICMP traffic from ${ingress_security_rules.value.desc}"
      stateless   = false
      source      = ingress_security_rules.value.source
      source_type = "CIDR_BLOCK"
      protocol    = local.protocol.ICMP
      icmp_options {
        type = ingress_security_rules.value.type
        code = lookup(ingress_security_rules.value, "code", null)
      }
    }
  }

  # UDP rules
  dynamic "ingress_security_rules" {
    for_each = var.private_udp_ingress_rules
    content {
      description = ingress_security_rules.value.desc
      stateless   = false
      source      = ingress_security_rules.value.source
      source_type = "CIDR_BLOCK"
      protocol    = local.protocol.UDP
      udp_options {
        min = ingress_security_rules.value.port
        max = ingress_security_rules.value.port
      }
    }
  }
}
