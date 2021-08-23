variable "cassandra_ami" {
  default = "ami-07f9fd4d008b06434"
}
variable "cassandra_ami_override" {
  type = map
  default = {}
}

variable "cassandra_root_block_device_size" {
  type = number
  default = 8
}
variable "cassandra_root_block_device_size_override" {
  type = map
  default = {}
}

variable "region" {
  default = "us-east-1"
}


variable "availability_zones" {
  default = [
    "us-west-1a",
    "us-west-1b",
  ]
}

variable "cassandra_instance_type" {
  default = "t2.micro"
}

variable "cassandra_seeds" { type=number }
variable "cassandra_nodes" { type=number }
variable "cassandra_cluster" { type=string }

variable "cassandra_deployer_key_name" { type=string }
variable "cassandra_deployer_key_name_override" {
  type = map
  default = {}
}

variable "zone_id" {
  description = "The private DNS zone to create records for hosts"
  default = "xxxxxxx"
}
variable "zone_name" {
  description = "The private DNS zone name to create records for hosts"
  default = "wbx12.net"
}
variable "sg_bastion_id" {
  default = "sg-554a2b1d"
}
variable "sg_tfe_id"{
  default = "sg-554a2b1d"
}
variable "sg_ansible_ssh"{
  default = "sg-554a2b1d"
}

variable "acm_arn" {}


variable "provisioning_user" {
  default = "ubuntu"
}

variable "cassandra_subnets"{
  description = ""
  type = map
  default = {}
}

variable "vpc_id" {
  default = "vpc-55f72a33"
}

variable "private_key_file_path" {
  description = "ssh key file for user"
  type = string
}
variable "private_key_file_path_override" {
  type = map
  default = {}
}

variable "ebs_optimized" {
  default = "false"
}

variable "alarms_email" {
  type = string
  default = "samuyu@cisco.com"
#  default = "sd_collabs@ciscospark.pagerduty.com"
}