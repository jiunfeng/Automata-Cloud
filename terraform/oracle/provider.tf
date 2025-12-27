terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 4.0.0"
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}


# 取得可用區資料
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}


terraform {
  backend "oci" {
    bucket    = "terraform-state-bucket"
    namespace = "nrdhcly6dzvu"
    key       = "Project_Free_Tier/terraform.tfstate"
    region    = "ap-tokyo-1"
    # 認證可以使用環境變數，或指定 profile

  }
}
