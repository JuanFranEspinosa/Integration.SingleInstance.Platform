module "single_instance" {
  source                   = "git@github.com:eVisionSoftware/Infrastructure.SingleInstance.Deployment//aws/deployment?ref=main"
  arcgis_login_secret      = var.arcgis_login_secret
  artifactory_access_token = var.artifactory_access_token
  artifactory_username     = var.artifactory_username
  hosted_zone_name         = var.domain_name
  instance_name            = var.instance_name
  key_name                 = "integrationteam-key"
  packages                 = var.packages
  tags                     = module.standard_tags.tags
}


module "accounts" {
  source = "git@github.com:eVisionSoftware/Infrastructure.Modules.AccountMappings"
}


output "url" {
  value = module.single_instance.url
}

