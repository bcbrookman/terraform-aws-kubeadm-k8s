locals {
  # Input variable transforms
  apiserver_dns            = var.apiserver_dns == "CLUSTERNAME-RANDOM.elb.REGION.amazonaws.com" ? "" : var.apiserver_dns
  containerd_version       = var.containerd_version == "auto" ? "" : var.containerd_version
  kubernetes_version       = var.kubernetes_version == "auto" ? "" : var.kubernetes_version
  controlplane_node_ami_id = var.controlplane_node_ami_id == "auto" ? data.aws_ami.debian12.id : var.controlplane_node_ami_id
  worker_node_ami_id       = var.worker_node_ami_id == "auto" ? data.aws_ami.debian12.id : var.worker_node_ami_id
  ssh_key_name             = var.ssh_key_name == "none" ? "" : var.ssh_key_name
}

resource "aws_instance" "controlplane_nodes" {
  count                = var.controlplane_node_count
  ami                  = local.controlplane_node_ami_id
  instance_type        = var.controlplane_node_instance_type
  subnet_id            = var.subnet_id
  key_name             = local.ssh_key_name
  iam_instance_profile = aws_iam_instance_profile.node.name

  user_data_base64 = base64encode(templatefile(
    "${path.module}/user_data.sh.tftpl",
    {
      apiserver_dns           = coalesce(local.apiserver_dns, aws_lb.apiserver.dns_name)
      apiserver_port          = var.apiserver_port
      containerd_version      = local.containerd_version
      first_controlplane_node = count.index == 0 ? "true" : ""
      kubernetes_version      = local.kubernetes_version
      node_role               = "control-plane"
      s3_bucket_name          = aws_s3_bucket.kubeadm_cmds.id
    }
  ))

  tags = {
    Name = format("%s%02s", "${var.cluster_name}-cp", count.index + 1)
  }

  depends_on = [
    aws_lb.apiserver
  ]
}

resource "aws_instance" "worker_nodes" {
  count                = var.worker_node_count
  ami                  = local.worker_node_ami_id
  instance_type        = var.worker_node_instance_type
  subnet_id            = var.subnet_id
  key_name             = local.ssh_key_name
  iam_instance_profile = aws_iam_instance_profile.node.name

  user_data_base64 = base64encode(templatefile(
    "${path.module}/user_data.sh.tftpl",
    {
      apiserver_dns           = coalesce(local.apiserver_dns, aws_lb.apiserver.dns_name)
      apiserver_port          = var.apiserver_port
      containerd_version      = local.containerd_version
      first_controlplane_node = ""
      kubernetes_version      = local.kubernetes_version
      node_role               = "worker"
      s3_bucket_name          = aws_s3_bucket.kubeadm_cmds.id
    }
  ))

  tags = {
    Name = format("%s%02s", "${var.cluster_name}-wk", count.index + 1)
  }
}
