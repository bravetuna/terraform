resource "aws_iam_instance_profile" "cassandra_profile" {
  name = "${var.cassandra_cluster}-cassandra_profile"
  role = aws_iam_role.cassandra_configuration.name
}

data "aws_ssm_parameter" "ssh_private_key" {
  count = var.cassandra_nodes
  name = lookup(var.private_key_file_path_override, tostring(count.index), var.private_key_file_path)
}

resource "aws_instance" "cassandra_nodes" {
  ami                     = lookup(var.cassandra_ami_override, tostring(count.index), var.cassandra_ami)
  instance_type           = var.cassandra_instance_type
  key_name                = lookup(var.cassandra_deployer_key_name_override, tostring(count.index), var.cassandra_deployer_key_name)
  availability_zone       = "${var.availability_zones[count.index % length(var.availability_zones)]}"
  vpc_security_group_ids  = [var.sg_bastion_id, var.sg_tfe_id, var.sg_ansible_ssh, "${aws_security_group.cassandra.id}", "${aws_security_group.egress.id}"]
  count                   = var.cassandra_nodes
  iam_instance_profile    = aws_iam_instance_profile.cassandra_profile.name
  subnet_id               = "${var.cassandra_subnets[var.availability_zones[count.index % length(var.availability_zones)]]}"
#  subnet_id               = "subnet-9418c0ce"
#  user_data               = "${file("${path.module}/mount.sh")}"
  user_data = <<-EOT
    echo "il5-cassandra-${var.cassandra_cluster}-${replace(var.availability_zones[count.index % length(var.availability_zones)], "-", "")}-${floor(count.index/length(var.availability_zones))+1}" > /tmp/log
  EOT
  disable_api_termination = false
#  disable_api_termination = true
  tags                    = {
    Name      = "il5-cassandra-${var.cassandra_cluster}-${replace(var.availability_zones[count.index % length(var.availability_zones)], "-", "")}-${floor(count.index/length(var.availability_zones))+1}"
    Cluster   = var.cassandra_cluster
    NodeType  = count.index < var.cassandra_seeds ? "seed" : "nonseed"
  }

  root_block_device {
    volume_size = tonumber(lookup(var.cassandra_root_block_device_size_override, tostring(count.index), var.cassandra_root_block_device_size))
  }
}

/*
resource "null_resource" "configure-cassandra-tls" {
  depends_on = [data.template_file.configure-cassandra-tls, null_resource.cassandra_boot]
  count = var.cassandra_nodes

  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    cluster_instance_ids = "${aws_instance.cassandra_nodes[count.index].id}"
    version = "5"
  }

  connection {
    host = aws_instance.cassandra_nodes.*.private_ip[count.index]
    user = var.provisioning_user
    private_key = data.aws_ssm_parameter.ssh_private_key[count.index].value
  }
  provisioner "file" {
    content = file("${path.module}/templates/security.java")
    destination = "/tmp/security.java"
  }
  provisioner "file" {
    content = data.template_file.configure-cassandra-tls.rendered
    destination = "/tmp/setup-cassandra-tls"
  }
  provisioner "file" {
    content = data.template_file.configure-consul.rendered
    destination = "/tmp/setup-consul"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo hostname agovw1-cassandra-${var.cassandra_cluster}-${replace(var.availability_zones[count.index % length(var.availability_zones)], "-", "")}-${floor(count.index/length(var.availability_zones))+1}",
      "sudo sh -c \"echo 'agovw1-cassandra-${var.cassandra_cluster}-${replace(var.availability_zones[count.index % length(var.availability_zones)], "-", "")}-${floor(count.index/length(var.availability_zones))+1}' > /etc/hostname\"",
      "sudo sh -c \"echo '127.0.0.1 localhost agovw1-cassandra-${var.cassandra_cluster}-${replace(var.availability_zones[count.index % length(var.availability_zones)], "-", "")}-${floor(count.index/length(var.availability_zones))+1}' > /etc/hosts\"",
      "sudo apt-get update",
      "sudo apt-get update",
      "sudo apt-get install jq python-pip rng-tools openjdk-8-jre -y",
      "sudo pip install awscli",
      "sudo mv /tmp/security.java /etc/java-8-openjdk/security/java.security",
      "cd /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext/",
      "sudo wget https://downloads.bouncycastle.org/fips-java/bc-fips-1.0.1.jar",
      "sudo wget https://downloads.bouncycastle.org/fips-java/bctls-fips-1.0.8.jar",
      "cd -",
      "sudo mv /tmp/setup-cassandra-tls /usr/sbin/setup-cassandra-tls",
      "chmod +x /usr/sbin/setup-cassandra-tls",
      "sudo bash /usr/sbin/setup-cassandra-tls",
      "sudo mv /tmp/setup-consul /usr/sbin/setup-consul",
      "chmod +x /usr/sbin/setup-consul",
      "sudo bash /usr/sbin/setup-consul"
    ]
  }
}

resource "null_resource" "cassandra_boot" {
  depends_on = [aws_instance.cassandra_nodes]
  provisioner "local-exec" {
    command = "sleep 60"
  }
}
*/