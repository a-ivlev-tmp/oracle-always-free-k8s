data "oci_core_images" "workers" {
  compartment_id           = var.compartment_id
  operating_system         = var.workers_shared_conf.image.operating_system
  operating_system_version = var.workers_shared_conf.image.operating_system_version
  shape                    = var.workers_shared_conf.shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

resource "oci_core_instance" "worker" {
  for_each = { for worker in var.workers : worker.name => worker }

  compartment_id      = var.compartment_id
  availability_domain = local.availability_domain

  display_name = each.value.name

  shape = each.value.shape
  shape_config {
    ocpus         = each.value.ocpus
    memory_in_gbs = each.value.memory_in_gbs
  }
  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.workers.images[0].id
  }

  create_vnic_details {
    assign_public_ip          = var.workers_shared_conf.assign_public_ip
    subnet_id                 = var.workers_shared_conf.subnet_id
    assign_private_dns_record = true
    hostname_label            = each.value.name
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_key_pub_path)
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [source_details]
  }
}
