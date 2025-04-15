module "controlplane-nodes" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.7.1"

  ami                  = var.controlplane_node_ami_id == null ? data.aws_ami.debian12.id : var.controlplane_node_ami_id
  count                = var.controlplane_node_count
  iam_instance_profile = aws_iam_instance_profile.node_instance_profile.name
  instance_type        = var.controlplane_node_instance_type
  key_name             = var.ssh_key_name
  name                 = format("%s%02s", "${var.cluster_name}-cp", count.index + 1)
  subnet_id            = var.subnet_id

  user_data_base64 = base64encode(templatefile("${path.module}/user_data.sh.tftpl", {
    containerd_version      = var.containerd_version
    first_controlplane_node = count.index == 0 ? "true" : ""
    kubernetes_version      = var.kubernetes_version
    kubernetes_version      = var.kubernetes_version
    node_role               = "control-plane"
    s3_bucket_name          = aws_s3_bucket.kubeadm_cmds.id
  }))
}

module "worker-nodes" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.7.1"

  ami                  = var.worker_node_ami_id == null ? data.aws_ami.debian12.id : var.worker_node_ami_id
  count                = var.worker_node_count
  iam_instance_profile = aws_iam_instance_profile.node_instance_profile.name
  instance_type        = var.worker_node_instance_type
  key_name             = var.ssh_key_name
  name                 = format("%s%02s", "${var.cluster_name}-wk", count.index + 1)
  subnet_id            = var.subnet_id

  user_data_base64 = base64encode(templatefile("${path.module}/user_data.sh.tftpl", {
    containerd_version      = var.containerd_version
    first_controlplane_node = ""
    kubernetes_version      = var.kubernetes_version
    kubernetes_version      = var.kubernetes_version
    node_role               = "worker"
    s3_bucket_name          = aws_s3_bucket.kubeadm_cmds.id
  }))
}
