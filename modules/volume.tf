resource "aws_ebs_volume" "data" {
#  size = 10
  size = var.data_disk_size
  encrypted = true
#  encrypted = false
  type = var.data_disk_type
  iops = var.data_disk_iops
  availability_zone = "${var.availability_zones[count.index % length(var.availability_zones)]}"
  #availability_zone = data.aws_subnet.selected.*.availability_zone[count.index]
  tags = {
    owner = var.cluster_type
    Name      = "il5-volume-${var.db_cluster}-${replace(var.availability_zones[count.index % length(var.availability_zones)], "-", "")}-${floor(count.index/length(var.availability_zones))+1}"
  }
  count = var.db_nodes
  #  count = var.ebs_optimized ? var.data_instance_count : 0#
}

resource "aws_volume_attachment" "data_attachment" {
  device_name = "/dev/xvdh"
  volume_id = aws_ebs_volume.data.*.id[count.index]
  instance_id = aws_instance.nodes.*.id[count.index]
  #count = var.ebs_optimized ? var.data_instance_count : 0
  count = var.db_nodes
  force_detach = false
  skip_destroy = true
}
