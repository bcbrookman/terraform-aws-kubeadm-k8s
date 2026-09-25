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
          "ssm:GetParameter",
          "ssm:PutParameter",
        ]
        Resource = [
          aws_ssm_parameter.controlplane_join_command.arn,
          aws_ssm_parameter.worker_join_command.arn
        ]
      },
    ]
  })
}
