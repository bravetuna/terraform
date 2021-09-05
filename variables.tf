variable "aws_region" {
  default = "us-west-2"
}



variable "zone_id" {
  default = "Z30CMLYQNFNZR6"
}

variable "domain_name" {
  default = "wbx12.com"
}

# DB Specific

variable "db_ami" {
  default = "ami-03d5c68bab01f3496"
}

variable "db_instance_type" {
  default = "t2.micro"
}

variable "cluster_type" {
  default = "mysql"
}

variable "meetings_vpc_id" {
  default = "vpc-0ee26e893c7bd266e"
}

variable "messages_vpc_id" {
  default = "vpc-0a6944105f5f65d49"
}

variable "db_deployer_key_name" {
  default = "tmp-bastion-key"
}

variable "db_sg_id" {
  default = ["sg-554a2b1d"]
}

variable "db_zone_name" {
  default = "wbx12.com"
}

variable "data_disk_size" {
  default = 20
}

variable "data_disk_type" {
  default = "io2"
}

variable "data_disk_iops" {
  default = 1000
}

variable "db_availability_zones" {
  default = [
  "us-west-2a",
  "us-west-2b",
  "us-west-2c",
  ]
}

variable "meetings_db_subnets" {
  type = map
  default = {
    us-west-2a = "subnet-03bfddb3ce495a184"
    us-west-2b = "subnet-044ff358cc4b540ad"
    us-west-2c = "subnet-05ba7dec88d40fc06"
  }
}

variable "bastion_sg_id" {
  default = "sg-0673463dbbe0c3e07"
}

variable "db_ingress_ports" {
  description = "Allowed Ec2 ports"
  type        = map
  default     = {
    "3306"  = ["10.1.0.0/21","10.0.0.0/21"]
    "80" = ["0.0.0.0/0"]
    "443" = ["0.0.0.0/0"]
  }
}

variable "messages_db_subnets" {
  type = map
  default = {
    us-west-2a = "subnet-0a2c5b9ce38045007"
    us-west-2b = "subnet-0866ea7ad74920794"
    us-west-2c = "subnet-098417377233c3386"
  }
}
