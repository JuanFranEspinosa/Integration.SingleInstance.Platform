provider "aws" {
  region              = "eu-west-1"
  allowed_account_ids = [module.accounts.accounts.engineering]
  assume_role {
    role_arn = "arn:aws:iam::${module.accounts.accounts.engineering}:role/Janitor"
  }
}
