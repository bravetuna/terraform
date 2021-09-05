resource "aws_iam_instance_profile" "db_profile" {
  name = "${var.db_cluster}-${var.cluster_type}_profile"
  role = aws_iam_role.db_configuration.name
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
  iam_instance_profile    = aws_iam_instance_profile.db_profile.name
  vpc_security_group_ids  = [var.bastion_sg_id, var.sg_tfe_id, var.sg_ansible_ssh, "${aws_security_group.db_ingress.id}", "${aws_security_group.db_egress.id}"]
#  vpc_security_group_ids  = [var.bastion_sg_id, var.sg_tfe_id, var.sg_ansible_ssh, "${aws_security_group.db.id}", "${aws_security_group.db_egress.id}"]
  subnet_id               = "${var.db_subnets[var.availability_zones[count.index % length(var.availability_zones)]]}"
  user_data               = "${file("${path.module}/init_data.sh")}"
  disable_api_termination = false
#  function_type           = var.function_type
#  cluster_type            = var.cluster_type
  tags                    = {
#il5-usgovw-2a-postgres-configdb-1
    Name      = "il5-${replace(var.availability_zones[count.index % length(var.availability_zones)], "-", "")}-${var.function_type}-${var.cluster_type}-${var.db_cluster}-${floor(count.index/length(var.availability_zones))+1}"
    Cluster   = var.db_cluster
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
    volume_size = 40
    encrypted = true
    delete_on_termination = false
  }
}

