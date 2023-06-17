terraform {
  cloud {
    organization = "poorsam"

    hostname = "app.terraform.io"

    workspaces {
      name = "aws-terraform"
    }
  }
}