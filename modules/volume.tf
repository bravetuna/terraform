resource "aws_ebs_volume" "data" {
  size = 100
  encrypted = true
  type = "io1"
  iops = 1000
  availability_zone = "${var.availability_zones[count.index % length(var.availability_zones)]}"
  #availability_zone = data.aws_subnet.selected.*.availability_zone[count.index]
  tags = {
    owner = "cassandra"
  }
  count = var.cassandra_nodes
  #  count = var.ebs_optimized ? var.data_instance_count : 0#
}

resource "aws_volume_attachment" "data_attachment" {
  device_name = "/dev/xvdh"
  volume_id = aws_ebs_volume.data.*.id[count.index]
  instance_id = aws_instance.cassandra_nodes.*.id[count.index]
  #count = var.ebs_optimized ? var.data_instance_count : 0
  count = var.cassandra_nodes
  force_detach = true
}