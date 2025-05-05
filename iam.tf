resource "aws_iam_role" "node" {
  name = "${var.cluster_name}-node-iam-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "node" {
  name = "${var.cluster_name}-node-instance-profile"
  role = aws_iam_role.node.name
}

resource "aws_iam_role_policy" "node" {
  name = "${var.cluster_name}-node-iam-role-policy"
  role = aws_iam_role.node.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:ListBucket",
          "s3:GetObject"
        ]
        Resource = [
          aws_s3_bucket.kubeadm_cmds.arn,
          "${aws_s3_bucket.kubeadm_cmds.arn}/*"
        ]
      },
    ]
  })
}
