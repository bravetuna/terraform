resource "aws_s3_bucket" "backups" {
  count = var.db_nodes > 0 ? 1 : 0
  bucket        = replace(lower("${var.cluster_type}-${var.db_cluster}-backups"),"_","-")
  acl           = "private"
  force_destroy = true

  tags = {
    Name    = "${var.cluster_type} ${var.db_cluster} backups"
    Cluster = var.db_cluster
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
  lifecycle {
    ignore_changes = [
      lifecycle_rule["expiration"]
    ]
  }
}

data "aws_kms_alias" "s3" {
  provider = aws.backup_region
  name = "alias/aws/s3"
}
