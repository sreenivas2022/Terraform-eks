module "ecr" {
  source = "./modules/ecr"

  ecr_name          = var.ecr_name
  environment       = var.environment
  project           = var.project
  created_by        = var.created_by
  created_date      = var.created_date
  cross_account_ids = var.cross_account_ids
}