module "billings" {
  source                           = "../modules"
  region                           = var.aws_region
  availability_zones               = var.db_availability_zones
  #s3_remote_backup_region          = var.s3_remote_backup_region
  db_subnets                = var.meetings_db_subnets
  db_nodes                        = 1 
  db_cluster                = "billings"
  owner_group                      = var.owner_group
  owner_contact                      = "il5-dba@wbx13.com"
  microservice                      = "revenue"
  function_type                    = "meetings"
  cluster_type                     = "PostgreSQL"
  cluster_environment                     = "BTS"
  db_deployer_key_name      = var.db_deployer_key_name
  vpc_id                           = var.meetings_vpc_id
  db_ami                    = var.rhel_ami
  db_os                    = var.rhel_os_type
#  db_ami                    = var.ubuntu_ami
#  db_os                    = var.ubuntu_os_type
  db_instance_type          = "m4.xlarge"
  db_root_block_device_size = 120
  zone_id                          = "Z0989486167Z7IGOGKJEK"
  zone_name                        = var.db_zone_name
  ebs_volume_1 = {
      volume_label = "data"
      volume_type = "io2"
      volume_size = 30
      volume_iops = 4000
      fs_type = "xfs"
      fs_mount_point = "/billing_data"
      fs_mount_option = "defaults,noatime,nodiratime"
    }
  ebs_volume_2 = {
      volume_label = "archive"
      volume_type = "io2"
      volume_size = 100
      volume_iops = 5000
      fs_type = "xfs"
      fs_mount_point = "/billing_db_archive"
      fs_mount_option = "defaults"
    }
  ebs_volume_3 = {
      volume_label = "log"
      volume_type = "io2"
      volume_size = 0 
      volume_iops = 1000
      fs_type = "xfs"
      fs_mount_point = "/billing_app_db_logs"
      fs_mount_option = "defaults"
    }
  bastion_sg_id         = var.bastion_sg_id
  db_ingress_ports                 = var.postgres_ingress_ports

  #sg_tfe_id                   = data.terraform_remote_state.networking.outputs.sg_ssh_from_tfe["app"].id
  #sg_ansible_ssh        = data.terraform_remote_state.networking.outputs.sg_ssh_from_jenkins["app"].id
  #sg_bastion_id         = data.terraform_remote_state.networking.outputs.sg_ssh_from_bastion["app"].id
  #acm_arn               = data.terraform_remote_state.admin_bootstrap.outputs.private_rootca_arn
  acm_arn               = "abc"
  private_key_file_path = "/prod/bastion/ssh/private"
}
