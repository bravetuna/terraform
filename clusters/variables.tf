variable "aws_region" {
  default = "us-west-2"
}

variable "zone_id" {
  default = "Z30CMLYQNFNZR6"
}

variable "acm_arn" {
  default = "arn:aws:acm-pca:us-west-2:515256622047:certificate-authority/c525041f-570b-46ae-893b-3c9ec090cf8f"
}

variable "tls_cert_validity_days" {
  default = 180
}

variable "cert_number" {
  default = 1
}

variable "tls_common_name" {
  default = "*.wbx12.com"
}

variable "ssm_namespace" {
  default = "il5"
}

# DB Specific

variable "ubuntu_ami" {
  default = "ami-03d5c68bab01f3496"
}

variable "ubuntu_os_type" {
  default = "Ubuntu_20"
}

variable "rhel_ami" {
#  default = "ami-0686851c4e7b1a8e1"
  default = "ami-068bac79f8a34ce36"  #rhel-8 ami
}

variable "rhel_os_type" {
  default = "Rhel_8"
#  default = "CentOS_7"
}

variable "db_instance_type" {
  default = "t2.micro"
}

variable "cluster_type" {
  default = "MySQL"
}

variable "owner_group" {
  default = "Meetings_DBA"
}

variable "owner_contact" {
  default = "dba@wbx13.com"
}

variable "cluster_environment" {
  default = "PROD"
}

variable "microservice" {
  type = string
  default = "common"
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
  default = "wbx13.com"
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

variable "mysql_ingress_ports" {
  description = "Allowed Ec2 ports"
  type        = map
  default     = {
    "tcp/3306"  = ["10.1.0.0/21","10.0.0.0/21"]
    "tcp/22" = ["10.0.0.0/8"]
    "tcp/80" = ["10.0.0.0/8"]
    "tcp/443" = ["10.0.0.0/8"]
    "icmp/-1" = ["10.0.0.0/8"]
  }
}

variable "postgres_ingress_ports" {
  description = "Allowed Ec2 ports"
  type        = map
  default     = {
    "tcp/5432"  = ["10.1.0.0/21","10.0.0.0/21"]
    "tcp/22" = ["10.0.0.0/8"]
    "tcp/80" = ["10.0.0.0/8"]
    "tcp/81" = ["10.0.0.0/8"]
    "tcp/8080" = ["10.0.0.0/8"]
    "tcp/443" = ["10.0.0.0/8"]
    "icmp/-1" = ["10.0.0.0/8"]
  }
}

variable "redis_ingress_ports" {
  description = "Allowed Ec2 ports"
  type        = map
  default     = {
    "tcp/6379"  = ["10.1.0.0/21","10.0.0.0/21"]
    "tcp/22" = ["10.0.0.0/8"]
    "tcp/80" = ["10.0.0.0/8"]
    "tcp/81" = ["10.0.0.0/8"]
    "tcp/8080" = ["10.0.0.0/8"]
    "tcp/443" = ["10.0.0.0/8"]
    "icmp/-1" = ["10.0.0.0/8"]
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

variable "ebs_volume_1" {
  type = map
  default = {
      volume_label = "data"
      volume_type = "io2"
      volume_size = 50
      volume_iops = 4000
      fs_type = "xfs"
      fs_mount_point = "/analytics_data"
      fs_mount_option = "defaults,noatime,nodiratime"
    }
}

variable "ebs_volume_2" {
  type = map
  default = {
      volume_label = "archive"
      volume_type = "io2"
      volume_size = 200
      volume_iops = 3000
      fs_type = "xfs"
      fs_mount_point = "/database_archive"
      fs_mount_option = "defaults"
    }
}

variable "ebs_volume_3" {
  type = map
  default = {
      volume_label = "log"
      volume_type = "io2"
      volume_size = 100
      volume_iops = 10000
      fs_type = "xfs"
      fs_mount_point = "/db_logs"
      fs_mount_option = "defaults"
    }
}

