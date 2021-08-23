/*terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}
*/

provider "aws" {
  profile = "default"
  region  = "us-west-1"
}

/*
data "aws_route53_zone" "selected" {
  name         = "${var.cassandra_zone_name}."
  private_zone = true
}
*/


module "calendar" {
  source                           = "./modules"
  #source                           = "tfe-fedramp.ciscospark.com/fedramp/tf-module-cassandra/aws"
  #version                          = "0.0.30"
  region                           = var.aws_region
  availability_zones               = var.cassandra_availability_zones
  #s3_remote_backup_region          = var.s3_remote_backup_region
  cassandra_subnets                = var.cassandra_subnets
  cassandra_seeds                  = 1
  cassandra_nodes                  = 2
  #cert_number                      = 3
  cassandra_cluster                = "calendar"
  cassandra_deployer_key_name      = "oliver12"
  vpc_id                           = var.cassandra_vpc_id
  cassandra_ami                    = var.cassandra_ami
  cassandra_instance_type          = "t2.micro"
  cassandra_root_block_device_size = 30
#  zone_id                          = data.aws_route53_zone.selected.zone_id
  zone_id                          = "Z0177144JRGBUNGWTRDE"
  zone_name                        = var.cassandra_zone_name
  sg_tfe_id                        = "sg-0d248309814203d1f"
  #sg_tfe_id                   = data.terraform_remote_state.networking.outputs.sg_ssh_from_tfe["app"].id
  #sg_ansible_ssh        = data.terraform_remote_state.networking.outputs.sg_ssh_from_jenkins["app"].id
  #sg_bastion_id         = data.terraform_remote_state.networking.outputs.sg_ssh_from_bastion["app"].id
  #acm_arn               = data.terraform_remote_state.admin_bootstrap.outputs.private_rootca_arn
  acm_arn               = "abc"
  private_key_file_path = "/agovw1/oliver12_private_key"
}

module "meet" {
  source                           = "./modules"
  #source                           = "tfe-fedramp.ciscospark.com/fedramp/tf-module-cassandra/aws"
  #version                          = "0.0.30"
  region                           = var.aws_region
  availability_zones               = var.cassandra_availability_zones
  #s3_remote_backup_region          = var.s3_remote_backup_region
  cassandra_subnets                = var.cassandra_subnets
  cassandra_seeds                  = 2
  cassandra_nodes                  = 4
  #cert_number                      = 3
  cassandra_cluster                = "meet"
  cassandra_deployer_key_name      = "oliver12"
  vpc_id                           = var.cassandra_vpc_id
  cassandra_ami                    = var.cassandra_ami
  cassandra_instance_type          = "t2.micro"
  cassandra_root_block_device_size = 8
#  zone_id                          = data.aws_route53_zone.selected.zone_id
  zone_id                          = "Z0177144JRGBUNGWTRDE"
  zone_name                        = var.cassandra_zone_name
  sg_tfe_id                        = "sg-0d248309814203d1f"
  #sg_tfe_id                   = data.terraform_remote_state.networking.outputs.sg_ssh_from_tfe["app"].id
  #sg_ansible_ssh        = data.terraform_remote_state.networking.outputs.sg_ssh_from_jenkins["app"].id
  #sg_bastion_id         = data.terraform_remote_state.networking.outputs.sg_ssh_from_bastion["app"].id
  #acm_arn               = data.terraform_remote_state.admin_bootstrap.outputs.private_rootca_arn
  acm_arn               = "abc"
  private_key_file_path = "/agovw1/oliver12_private_key"
}


