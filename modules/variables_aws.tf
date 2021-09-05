variable "db_ami" {
  default = "ami-07c3d21e3451949dd"
}

variable "db_ami_override" {
  type = map
  default = {}
}

variable "data_disk_size" {
  type = number
}

variable "data_disk_type" {
  type = string
}

variable "data_disk_iops" {
  type = number
}

variable "db_root_block_device_size" {
  type = number
  default = 8
}
variable "db_root_block_device_size_override" {
  type = map
  default = {}
}

variable "region" {
  default = "us-west-2"
}


variable "availability_zones" {
  default = [
    "us-west-2a",
    "us-west-2b",
    "us-west-2c",
  ]
}

variable "db_instance_type" {
  default = "t2.micro"
}

variable "db_nodes" { type=number }
variable "db_cluster" { type=string }

variable "db_deployer_key_name" { type=string }
variable "db_deployer_key_name_override" {
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

variable "bastion_sg_id" {
  type = string
}

variable "sg_tfe_id"{
  default = "sg-0106fe5aaf0749f68"
}

variable "sg_ansible_ssh"{
  default = "sg-0106fe5aaf0749f68"
}

variable "acm_arn" {}


variable "provisioning_user" {
  default = "ubuntu"
}

variable "db_subnets"{
  description = ""
  type = map
  default = {}
}

variable "db_ingress_ports"{
  description = ""
  type = map
  default = {}
}

variable "meetings_vpc_id" {
  default = "vpc-008e9e908621b8506"
}

variable "messages_vpc_id" {
  default = "vpc-0a6944105f5f65d49"
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

variable "function_type" {
# meetings or messages
  type = string
}

variable "cluster_type" {
# mysql or postgres or redis
  type = string
}

variable "alarms_email" {
  type = string
  default = "samuyu@cisco.com"
#  default = "sd_collabs@ciscospark.pagerduty.com"
}
