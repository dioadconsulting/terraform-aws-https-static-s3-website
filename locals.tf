locals {
  dns_records         = setunion([var.domain_name], var.domain_aliases)
  dns_records_as_list = list(setunion([var.domain_name], var.domain_aliases))
}