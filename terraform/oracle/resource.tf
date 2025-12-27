# 方法 B：動態搜尋 Image OCID
data "oci_core_images" "ubuntu_arm" {
  compartment_id           = var.compartment_id
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04"
  shape                    = "VM.Standard.A1.Flex" # 指定要給 ARM 用的 Image
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

# 建立 VM 實例
resource "oci_core_instance" "free_vm" {
  # 使用搜尋結果的第一筆 (最新的)
  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ubuntu_arm.images[0].id
  }

  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_id
  display_name        = "SRE-Free-ARM"
  shape               = "VM.Standard.A1.Flex"

  shape_config {
    ocpus         = 4
    memory_in_gbs = 24 # 1 OCPU + 6GB RAM 是安全的免費配額
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.main_subnet.id
    assign_public_ip = true
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }

  # 預防 Image 更新導致 VM 被重建 (SRE 常用技巧)
  lifecycle {
    ignore_changes = [source_details]
  }
}

# 輸出 Public IP
output "instance_public_ip" {
  value = oci_core_instance.free_vm.public_ip
}