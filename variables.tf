variable "aws_region" {
  default = "us-west-1"
}



variable "zone_id" {
  default = "Z30CMLYQNFNZR6"
}

variable "domain_name" {
  default = "wbx12.com"
}

# Cassandra Specific

variable "cassandra_ami" {
  default = "ami-07f9fd4d008b06434"
}

variable "cassandra_instance_type" {
  default = "t2.micro"
}

variable "cassandra_subnet_id" {
  default = "subnet-9418c0ce"
}

variable "cassandra_vpc_id" {
  default = "vpc-55f72a33"
}

variable "cassandra_sg_id" {
  default = ["sg-554a2b1d"]
}

variable "cassandra_zone_name" {
  default = "wbx12.com"
}



variable "cassandra_availability_zones" {
  default = [
  "us-west-1a",
  "us-west-1b",
  ]
}

variable "cassandra_subnets" {
  type = map
  default = {
    us-west-1a = "subnet-9418c0ce"
    us-west-1b = "subnet-33038f55"
  }
}
