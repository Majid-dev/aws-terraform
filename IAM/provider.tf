terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAWV7PGVQTOYUUKNNM"
  secret_key = "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"
}
