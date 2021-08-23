resource "aws_iam_role" "replication" {
  name = "tf-iam-role-cassrepl-${var.cassandra_cluster}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "replication" {
  name = "tf-iam-policy-cassrepl-${var.cassandra_cluster}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.backups.arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.backups.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.backup_remote.arn}/*"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}


resource "aws_s3_bucket" "backups" {
  bucket        = "agovw1-cassandra-${var.cassandra_cluster}-backups"
  acl           = "private"
  force_destroy = true

  tags = {
    Name    = "Cassandra ${var.cassandra_cluster} backups"
    Cluster = var.cassandra_cluster
  }

  lifecycle_rule {
    id      = "backups"
    enabled = true
    abort_incomplete_multipart_upload_days = 1

    expiration {
      days = 15
      expired_object_delete_marker = true
    }
    noncurrent_version_expiration {
      days = 1
    }
  }
  versioning {
    enabled = true
  }
  replication_configuration {
    role = aws_iam_role.replication.arn

    rules {
      id     = "replication-config-${var.cassandra_cluster}"
      prefix = ""
      status = "Enabled"

      destination {
        bucket        = aws_s3_bucket.backup_remote.arn
        storage_class = "STANDARD"
        replica_kms_key_id = data.aws_kms_alias.s3.target_key_arn
      }
      source_selection_criteria {
        sse_kms_encrypted_objects {
          enabled = true
        }
      }
    }
  }
}

data "aws_kms_alias" "s3" {
  provider = aws.backup_region
  name = "alias/aws/s3"
}
resource "aws_s3_bucket" "backup_remote" {
  provider = aws.backup_region
  bucket        = "agovw1-cassandra-${var.cassandra_cluster}-backups-remote"
  acl           = "private"
  force_destroy = true

  tags = {
    Name    = "Cassandra ${var.cassandra_cluster} backups"
    Cluster = var.cassandra_cluster
  }
  versioning {
    enabled = true
  }
  lifecycle_rule {
    id      = "backups"
    enabled = true
    abort_incomplete_multipart_upload_days = 1

    expiration {
      days = 30
      expired_object_delete_marker = true
    }

    noncurrent_version_expiration {
      days = 1
    }
  }
}
