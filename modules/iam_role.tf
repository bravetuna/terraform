resource "aws_iam_role_policy" "db_configuration" {
  name = "${var.db_cluster}-${var.cluster_type}-role-policy"
  role = aws_iam_role.db_configuration.id

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
      "Resource": ["arn:aws:s3:::il5-${var.cluster_type}-${var.db_cluster}-backups"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:ListObject"
      ],
      "Resource": ["arn:aws:s3:::il5-${var.cluster_type}-${var.db_cluster}-backups/*"]
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

resource "aws_iam_role" "db_configuration" {
  name = "${var.db_cluster}-${var.cluster_type}-role"

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

resource "aws_iam_role_policy_attachment" "ssm1-attach" {
  role = aws_iam_role.db_configuration.id
#  role       = aws_iam_role.role.name
#  policy_arn = aws_iam_policy.policy.arn
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ssm2-attach" {
  role = aws_iam_role.db_configuration.id
#  role       = aws_iam_role.role.name
#  policy_arn = aws_iam_policy.policy.arn
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMPatchAssociation"
}


