# Backend
terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "vladkoval"
    workspaces {
      name = "InfraProject-Jil-Vlad-Terraform"
    }
  }
}