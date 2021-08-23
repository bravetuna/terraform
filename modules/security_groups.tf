data "aws_vpc" "selected" {
  id = "${var.vpc_id}"
}

resource "aws_security_group" "egress" {
  name        = "cassandra_${var.cassandra_cluster}_egress"
  description = "Allow egress traffic"
  vpc_id      = "${data.aws_vpc.selected.id}"

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "cassandra" {

  name        = "cassandra_${var.cassandra_cluster}"
  description = "Allow Cassandra Communication"
  vpc_id      = "${data.aws_vpc.selected.id}"

}

resource "aws_security_group_rule" "cassandra_comm" {
  type            = "ingress"
  from_port       = 7000
  to_port         = 7000
  protocol        = "tcp"
  security_group_id = "${aws_security_group.cassandra.id}"
  source_security_group_id = "${aws_security_group.cassandra.id}"
  description = "Internode communication"
}

resource "aws_security_group_rule" "cassandra_commtls" {
  type            = "ingress"
  from_port       = 7001
  to_port         = 7001
  protocol        = "tcp"
  security_group_id = "${aws_security_group.cassandra.id}"
  source_security_group_id = "${aws_security_group.cassandra.id}"
  description = "TLS Internode communication"
}

resource "aws_security_group_rule" "cassandra_jmx" {
  type            = "ingress"
  from_port       = 7199
  to_port         = 7199
  protocol        = "tcp"
  security_group_id = "${aws_security_group.cassandra.id}"
  cidr_blocks = ["127.0.0.1/32"]
  description = "JMX"
}

# TODO: Refernece Splatrunners instead of cidr_block
resource "aws_security_group_rule" "cassandra_thrift" {
  type            = "ingress"
  from_port       = 9160
  to_port         = 9160
  protocol        = "tcp"
  security_group_id = "${aws_security_group.cassandra.id}"
  cidr_blocks = ["${data.aws_vpc.selected.cidr_block}"]
  description = "Thrift client API"
}

# TODO: Refernece Splatrunners instead of cidr_block
resource "aws_security_group_rule" "cassandra_cql" {
  type            = "ingress"
  from_port       = 9042
  to_port         = 9042
  protocol        = "tcp"
  security_group_id = "${aws_security_group.cassandra.id}"
  cidr_blocks = ["${data.aws_vpc.selected.cidr_block}"]
  description = "CQL native transport port"
}

resource "aws_security_group_rule" "temp_ssh_from_internet" {
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  security_group_id = "${aws_security_group.cassandra.id}"
  cidr_blocks = ["0.0.0.0/0"]
  description = "temp ssh from internet because there is no bastion yet"
}