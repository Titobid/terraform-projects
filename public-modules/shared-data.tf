locals {
  project_name = "public-vpc-module"
  common_tags = {
    project    = local.project_name
    managed_by = "terraform"
  }
}