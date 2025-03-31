data "oci_core_images" "workers" {
  compartment_id           = var.compartment_id
  operating_system         = var.workers.image.operating_system
  operating_system_version = var.workers.image.operating_system_version
  shape                    = var.workers.shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

resource "oci_core_instance" "worker" {
  compartment_id      = var.compartment_id
  availability_domain = local.availability_domain

  count        = var.workers.count
  display_name = "${var.workers.base_hostname}-${count.index + 1}"

  shape = var.workers.shape
  shape_config {
    ocpus         = var.workers.ocpus
    memory_in_gbs = var.workers.memory_in_gbs
  }
  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.workers.images[0].id
  }

  create_vnic_details {
    assign_public_ip          = var.workers.assign_public_ip
    subnet_id                 = var.workers.subnet_id
    assign_private_dns_record = true
    hostname_label            = "${var.workers.base_hostname}-${count.index + 1}"
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_key_pub_path)
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [source_details]
  }
}
