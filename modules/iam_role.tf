resource "aws_iam_role_policy" "cassandra_configuration" {
  name = "${var.cassandra_cluster}-cassandra-role-policy"
  role = aws_iam_role.cassandra_configuration.id

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
      "Action": ["s3:ListBucket"],
      "Resource": ["arn:aws:s3:::agovw1-cassandra-${var.cassandra_cluster}-backups"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:ListObject"
      ],
      "Resource": ["arn:aws:s3:::agovw1-cassandra-${var.cassandra_cluster}-backups/*"]
    },
    {
      "Action": [
        "ec2:DescribeInstances",
        "ec2:DescribeTags",
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

resource "aws_iam_role" "cassandra_configuration" {
  name = "${var.cassandra_cluster}-cassandra-role"

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
