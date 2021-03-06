module "analytics" {
  source                           = "../modules"
  region                           = var.aws_region
  availability_zones               = var.db_availability_zones
  #s3_remote_backup_region          = var.s3_remote_backup_region
  db_subnets                = var.meetings_db_subnets
  db_nodes                        = 2 
  db_cluster                = "analytics"
  owner_group                      = var.owner_group
  owner_contact                      = "il5-dba@wbx13.com"
  microservice                      = "call-analyzer"
  function_type                    = "meetings"
  cluster_type                     = var.cluster_type
  cluster_environment                     = "BTS"
  db_deployer_key_name      = var.db_deployer_key_name
  vpc_id                           = var.meetings_vpc_id
  db_ami                    = var.rhel_ami
  db_os                    = var.rhel_os_type
  db_instance_type          = "m5.xlarge"
  db_root_block_device_size = 100
  zone_id                          = "Z0989486167Z7IGOGKJEK"
  zone_name                        = var.db_zone_name
  ebs_volume_1 = {
      volume_label = "data"
      volume_type = "io2"
      volume_size = 50 
      volume_iops = 4000
      fs_type = "xfs"
      fs_mount_point = "/analytics_data"
      fs_mount_option = "defaults,noatime,nodiratime"
    }
  ebs_volume_2 = {
      volume_label = "archive"
      volume_type = "io2"
      volume_size = 200
      volume_iops = 8000
      fs_type = "xfs"
      fs_mount_point = "/database_archive"
      fs_mount_option = "defaults"
    }
  ebs_volume_3 = {
      volume_label = "log"
      volume_type = "io2"
      volume_size = 100
      volume_iops = 10000
      fs_type = "xfs"
      fs_mount_point = "/db_logs"
      fs_mount_option = "defaults"
    }
  bastion_sg_id         = var.bastion_sg_id
  db_ingress_ports                 = var.mysql_ingress_ports
  #sg_tfe_id                   = data.terraform_remote_state.networking.outputs.sg_ssh_from_tfe["app"].id
  #sg_ansible_ssh        = data.terraform_remote_state.networking.outputs.sg_ssh_from_jenkins["app"].id
  #sg_bastion_id         = data.terraform_remote_state.networking.outputs.sg_ssh_from_bastion["app"].id
  #acm_arn               = data.terraform_remote_state.admin_bootstrap.outputs.private_rootca_arn
  acm_arn               = "abc"
#  acm_arn        = local.root_ca_arn
#  ca_common_name = var.ca_common_name
#  cert_number    = 2
  private_key_file_path = "/prod/bastion/ssh/private"
}
