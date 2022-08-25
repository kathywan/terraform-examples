resource "aws_s3_bucket" "kwan_example" {
  bucket = local.kwan_example_name
  tags   = var.kwan_example_tags
}

resource "aws_s3_bucket_acl" "kwan_example" {
  bucket = local.kwan_example_name
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "kwan_example" {
  bucket = local.kwan_example_name
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_replication_configuration" "kwan_example" {
  bucket = local.kwan_example_name
  role   = aws_iam_role.s3_role_kwan_example.arn
  rule {
    id     = "${local.kwan_example_name}-replication-id"
    status = "Enabled"
    destination {
      encryption_configuration {
        replica_kms_key_id = aws_kms_key.kwan_example_us_west_1_crr.arn
      }
      bucket = aws_s3_bucket.kwan_example_us_west_1_crr.arn
    }
    source_selection_criteria {
      sse_kms_encrypted_objects {
        status = "Enabled"
      }
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "kwan_example" {
  bucket = local.kwan_example_name
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.kwan_example.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "kwan_example" {
  bucket = local.kwan_example_name
  rule {
    status = "Enabled"
    id     = "kwan_example lifecycle rule"
    transition {
      days          = 120
      storage_class = "INTELLIGENT_TIERING"
    }
    noncurrent_version_transition {
      noncurrent_days = 120
      storage_class   = "INTELLIGENT_TIERING"
    }
  }
}

resource "aws_s3_bucket" "kwan_example_us_west_1_crr" {
  provider = aws.us-west-1
  bucket   = local.kwan_example_crr
  tags     = var.kwan_example_us_west_1_crr_tags
}

resource "aws_s3_bucket_acl" "kwan_example_us_west_1_crr" {
  provider = aws.us-west-1
  bucket   = local.kwan_example_crr
  acl      = "private"
}

resource "aws_s3_bucket_versioning" "kwan_example_us_west_1_crr" {
  provider = aws.us-west-1
  bucket   = local.kwan_example_crr
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "kwan_example_us_west_1_crr" {
  provider = aws.us-west-1
  bucket   = local.kwan_example_crr
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.kwan_example_us_west_1_crr.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "kwan_example_us_west_1_crr" {
  provider = aws.us-west-1
  bucket   = local.kwan_example_crr
  rule {
    status = "Enabled"
    id     = "kwan_example_crr lifecycle rule"
    transition {
      days          = 120
      storage_class = "GLACIER"
    }
    noncurrent_version_transition {
      noncurrent_days = 120
      storage_class   = "GLACIER"
    }
  }
}
