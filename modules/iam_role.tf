resource "aws_iam_role_policy" "db_configuration" {
  name = "${var.db_cluster}-${var.cluster_type}-role-policy"
  count = var.db_nodes > 0 ? 1 : 0
  role = aws_iam_role.db_configuration[count.index].id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ssm:GetParameter"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "route53:*",
        "acm:*",
        "acm-pca:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": ["s3:*"],
      "Resource": ["arn:aws:s3:::il5-${var.cluster_type}-${var.db_cluster}-backups"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": ["arn:aws:s3:::il5-${var.cluster_type}-${var.db_cluster}-backups/*"]
    },
    {
      "Action": [
        "ec2:Describe*",
        "autoscaling:DescribeAutoScalingGroups",
        "cloudwatch:Describe"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "db_configuration" {
  name = "${var.db_cluster}-${var.cluster_type}-role"
  count = var.db_nodes > 0 ? 1 : 0

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
