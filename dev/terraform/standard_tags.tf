module "standard_tags" {
  source     = "git@github.com:eVisionSoftware/Infrastructure.Modules.StandardTags//create?ref=2.0.2"
  client     = "QualityControl"
  deployment = "Dev"

  project_description = "OVP Tests AWS VMs"

  cost_center  = "IntegrationTeam"
  project_code = " "

  # OPTIONAL PARAMETERS
  owner = {
    name  = "Jean François Espinosa"
    email = "j-f.espinosa@wolterskluwer.com"
  }

  end_date   = "2023-12-31"
  purpose    = "StoryTesting"
  repository = "https://github.com/eVisionSoftware/IntegrationPlatform.CodeStream.Infrastructure.TF"

}