provider "aws" {
  region              = "eu-west-1"
  allowed_account_ids = [module.accounts.accounts.sandbox]
  assume_role {
    role_arn = "arn:aws:iam::${module.accounts.accounts.sandbox}:role/Janitor"
  }
}