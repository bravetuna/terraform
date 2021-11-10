resource "aws_iam_instance_profile" "db_profile" {
  name = "${var.db_cluster}-${var.cluster_type}_profile"
  role = aws_iam_role.db_configuration[count.index].name
  count = var.db_nodes > 0 ? 1 : 0
}

data "aws_ssm_parameter" "ssh_private_key" {
  count = var.db_nodes
  name = lookup(var.private_key_file_path_override, tostring(count.index), var.private_key_file_path)
}

resource "aws_instance" "nodes" {
  ami                     = lookup(var.db_ami_override, tostring(count.index), var.db_ami)
  instance_type           = var.db_instance_type
  key_name                = lookup(var.db_deployer_key_name_override, tostring(count.index), var.db_deployer_key_name)
  availability_zone       = "${var.availability_zones[count.index % length(var.availability_zones)]}"
  count                   = var.db_nodes
  iam_instance_profile    = var.db_nodes > 0 ? aws_iam_instance_profile.db_profile[0].name : null
  vpc_security_group_ids  = var.db_nodes > 0 ?  [
    var.bastion_sg_id, var.sg_tfe_id, var.sg_ansible_ssh, aws_security_group.db_ingress[0].id,
    aws_security_group.db_egress[0].id
  ] : null
#  vpc_security_group_ids  = [var.bastion_sg_id, var.sg_tfe_id, var.sg_ansible_ssh, "${aws_security_group.db.id}", "${aws_security_group.db_egress.id}"]
  subnet_id               = "${var.db_subnets[var.availability_zones[count.index % length(var.availability_zones)]]}"
  user_data               = templatefile("${path.module}/init_data.sh.tpl", {
    cname = "${var.function_type}-${var.cluster_type}-${var.db_cluster}-${count.index+1}.${var.zone_name}"
    region = var.region
  } )
  disable_api_termination = false
#  function_type           = var.function_type
#  cluster_type            = var.cluster_type
  tags                    = {
    Name      = "${var.function_type}-${var.cluster_type}-${var.db_cluster}-${count.index+1}"
    cname      = "${var.function_type}-${var.cluster_type}-${var.db_cluster}-${count.index+1}.${var.zone_name}"
    server_type = var.cluster_type
    owner_group = var.owner_group
    owner_contact = var.owner_contact
    microservice = var.microservice
    cluster_name   = var.db_cluster
    environment   = var.cluster_environment
    os_type   = var.db_os
  }
/*
  provisioner "remote-exec" {
    inline = [
      "sudo mkdir /data",
      "sudo mkfs -t ext4 /dev/xvdh",
      "sudo echo '/dev/xvdh /data ext4 defaults,nofail 0 2' >> /etc/fstab",
      "sudo mount /data",
    ]
  }

  connection {
    host = aws_instance.data_node.*.private_ip[count.index]
    user = "ubuntu"
    private_key = data.aws_ssm_parameter."/il5/oliver12_private_key".value
  }
*/
  provisioner "local-exec" {
    command = "echo abc > /tmp/a"
  }

  root_block_device {
    volume_type = "gp2" 
    volume_size = var.db_root_block_device_size
    encrypted = true
    delete_on_termination = false
  }

  lifecycle {
    ignore_changes = [
      user_data
    ]
  }

}

