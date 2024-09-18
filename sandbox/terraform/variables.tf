variable "artifactory_access_token" {
  type        = string
  description = "Access token to artitactory"
}

variable "arcgis_login_secret" {
  type        = string
  description = "Access token to artitactory"
}

variable "artifactory_username" {
  type        = string
  description = "Artifactory username"
}


variable "domain_name" {
  type        = string
  description = "AWS domain name"
}


variable "instance_name" {
  type        = string
  description = "Name of the instance"
  default     = "SingleInstance.si.dev.enablon.io"
}

variable "key_name" {
  type        = string
  description = "Key pair assigned at launch"
  default     = "integrationteam-key"
}

variable "region" {
  default = "eu-west-1"
}

variable "tags" {
  type = map(string)
  default = {
    "name"        = "singleinstance"
    "environment" = "sandbox"
  }
}

variable "packages" {
  type = list(object({
    product = string,
    version = string
  }))
  default = [{
    product = "eVision.OneVisionPackage.ShowCase",
    version = "13.0.24"
  }]
}