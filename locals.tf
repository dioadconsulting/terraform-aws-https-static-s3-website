locals {
  dns_records = setunion([var.domain_name], var.domain_aliases)
}
