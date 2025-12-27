# VCN
resource "oci_core_vcn" "main_vcn" {
  cidr_block     = "10.0.0.0/16"
  compartment_id = var.compartment_id
  display_name   = "sre-free-vcn"
  dns_label      = "srevcn"
}

# Internet Gateway
resource "oci_core_internet_gateway" "ig" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main_vcn.id
  display_name   = "main-ig"
}

# Route Table
resource "oci_core_default_route_table" "main_rt" {
  manage_default_resource_id = oci_core_vcn.main_vcn.default_route_table_id
  route_rules {
    network_entity_id = oci_core_internet_gateway.ig.id
    destination       = "0.0.0.0/0"
  }
}

# Security List (開放 22 Port)
resource "oci_core_default_security_list" "main_sl" {
  manage_default_resource_id = oci_core_vcn.main_vcn.default_security_list_id
  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0"
    tcp_options {
      min = 22
      max = 22
    }
  }
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}

# Subnet
resource "oci_core_subnet" "main_subnet" {
  cidr_block        = "10.0.1.0/24"
  display_name      = "main-subnet"
  compartment_id    = var.compartment_id
  vcn_id            = oci_core_vcn.main_vcn.id
  security_list_ids = [oci_core_vcn.main_vcn.default_security_list_id]
  dns_label         = "main"
}