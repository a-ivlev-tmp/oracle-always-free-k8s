terraform {
  # backend "s3" {
  #   profile = "oci"
  #   bucket  = "tonemkovich-main-oci-bucket"
  #   key     = "oci-always-free-k8s/terraform.tfstate"
  #   region  = "uk-london-1"
  #   endpoints = {
  #     s3 = "https://freb0ffgjcqz.compat.objectstorage.eu-frankfurt-1.oraclecloud.com"
  #   }
  #   skip_region_validation      = true
  #   skip_credentials_validation = true
  #   skip_requesting_account_id  = true
  #   skip_metadata_api_check     = true
  #   skip_s3_checksum            = true
  #   use_path_style              = true
  # }
  required_providers {
    oci = {
      # source = "hashicorp/oci"
      source  = "oracle/oci"
      version = ">= 6.32.0"
    }
    null = {
      version = "3.1.0"
    }
    helm = {
      source = "hashicorp/helm"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "oci" {
  # auth                 = "InstancePrincipal"
  tenancy_ocid         = var.tenancy_ocid
  user_ocid            = var.user_ocid
  fingerprint          = var.fingerprint
  private_key_path     = pathexpand(var.private_key_path)
  private_key_password = var.private_key_password
  region               = var.region

}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "admin@oracle.cloud"
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "admin@oracle.cloud"
  }
}
