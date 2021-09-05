variable "vpc_id" {}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

resource "aws_security_group" "db_egress" {
  name        = "${var.cluster_type}_${var.db_cluster}_egress"
  description = "Allow egress traffic"
  vpc_id      = "${data.aws_vpc.selected.id}"

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db_ingress" {
  name        = "${var.cluster_type}_${var.db_cluster}_ingress"
  description = "Allow ${var.cluster_type} Communication"
  vpc_id      = "${data.aws_vpc.selected.id}"
  dynamic ingress {
    for_each = var.db_ingress_ports
    content {
      from_port   = ingress.key
      to_port     = ingress.key
      cidr_blocks = ingress.value
      protocol    = "tcp"
    }
  }
}
