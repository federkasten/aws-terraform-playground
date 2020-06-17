terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "aws-terraform-playground"
    key    = "aws-terraform-playground.tfstate"
    region = "ap-northeast-1"
  }
}

provider "aws" {
  version = "~> 2.0"
  region  = "ap-northeast-1"
}

module "job" {
  source = "./job/"
}

module "launch_template" {
  source = "./launch_template/"
  name = "aws-batch-example-template"
}

module "network" {
  source = "./network/"
}

module "queue" {
  source = "./queue/"
  subnet_id = module.network.main_subnet_id
  security_group_id = module.network.default_sucurity_group_id
  launch_template_id = module.launch_template.launch_template_id
}
