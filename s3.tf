resource "aws_s3_bucket" "kubeadm_cmds" {
  bucket_prefix = "${var.cluster_name}-kubeadm-cmds-"
  force_destroy = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "kubeadm_cmds" {
  bucket = aws_s3_bucket.kubeadm_cmds.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "kubeadm_cmds" {
  bucket                  = aws_s3_bucket.kubeadm_cmds.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
