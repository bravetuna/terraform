resource "aws_ebs_volume" "volume_1" {
  count = lookup(var.ebs_volume_1, "volume_size", 0) > 0 ? var.db_nodes : 0
  type                 = lookup(var.ebs_volume_1, "volume_type", "io2")
  size                 = lookup(var.ebs_volume_1, "volume_size", null)
  iops                 = lookup(var.ebs_volume_1, "volume_iops", null)
  encrypted = true

  availability_zone = "${var.availability_zones[count.index % length(var.availability_zones)]}"
  tags = {
    owner = var.cluster_type
    volume_label   = lookup(var.ebs_volume_1, "volume_label", "")
    fs_type   = lookup(var.ebs_volume_1, "fs_type", "ext4")
    fs_mount_point   = lookup(var.ebs_volume_1, "fs_mount_point", null)
    fs_mount_option  = lookup(var.ebs_volume_1, "fs_mount_option", null)
    Name      = "volume-${var.function_type}-${var.cluster_type}-${var.db_cluster}-${count.index+1}-volume_1"
  }
}

resource "aws_volume_attachment" "volume_1_attachment" {
  count = lookup(var.ebs_volume_1, "volume_size", 0) > 0 ? var.db_nodes : 0
  device_name = "/dev/xvdh"
  volume_id = aws_ebs_volume.volume_1.*.id[count.index]
  instance_id = aws_instance.nodes.*.id[count.index]
  force_detach = false
  skip_destroy = true
}

resource "aws_ebs_volume" "volume_2" {
  count = lookup(var.ebs_volume_2, "volume_size", 0) > 0 ? var.db_nodes : 0
  type                 = lookup(var.ebs_volume_2, "volume_type", "io2")
  size                 = lookup(var.ebs_volume_2, "volume_size", null)
  iops                 = lookup(var.ebs_volume_2, "volume_iops", null)
  encrypted = true

  availability_zone = "${var.availability_zones[count.index % length(var.availability_zones)]}"
  tags = {
    owner = var.cluster_type
    volume_label   = lookup(var.ebs_volume_2, "volume_label", "")
    fs_type   = lookup(var.ebs_volume_2, "fs_type", "ext4")
    fs_mount_point   = lookup(var.ebs_volume_2, "fs_mount_point", null)
    fs_mount_option  = lookup(var.ebs_volume_2, "fs_mount_option", null)
    Name      = "volume-${var.function_type}-${var.cluster_type}-${var.db_cluster}-${count.index+1}-volume_2"
  }
}

resource "aws_volume_attachment" "volume_2_attachment" {
  count = lookup(var.ebs_volume_2, "volume_size", 0) > 0 ? var.db_nodes : 0
  device_name = "/dev/xvdi"
  volume_id = aws_ebs_volume.volume_2.*.id[count.index]
  instance_id = aws_instance.nodes.*.id[count.index]
  force_detach = false
  skip_destroy = true
}

resource "aws_ebs_volume" "volume_3" {
  count = lookup(var.ebs_volume_3, "volume_size", 0) > 0 ? var.db_nodes : 0
  type                 = lookup(var.ebs_volume_3, "volume_type", "io2")
  size                 = lookup(var.ebs_volume_3, "volume_size", null)
  iops                 = lookup(var.ebs_volume_3, "volume_iops", null)
  encrypted = true

  availability_zone = "${var.availability_zones[count.index % length(var.availability_zones)]}"
  tags = {
    owner = var.cluster_type
    volume_label   = lookup(var.ebs_volume_3, "volume_label", "")
    fs_type   = lookup(var.ebs_volume_3, "fs_type", "ext4")
    fs_mount_point   = lookup(var.ebs_volume_3, "fs_mount_point", null)
    fs_mount_option  = lookup(var.ebs_volume_3, "fs_mount_option", null)
    Name      = "volume-${var.function_type}-${var.cluster_type}-${var.db_cluster}-${count.index+1}-volume_3"
  }
}

resource "aws_volume_attachment" "volume_3_attachment" {
  count = lookup(var.ebs_volume_3, "volume_size", 0) > 0 ? var.db_nodes : 0
  device_name = "/dev/xvdl"
  volume_id = aws_ebs_volume.volume_3.*.id[count.index]
  instance_id = aws_instance.nodes.*.id[count.index]
  force_detach = false
  skip_destroy = true
}
