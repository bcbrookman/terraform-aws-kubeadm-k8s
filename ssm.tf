resource "aws_ssm_parameter" "controlplane_join_command" {
  name        = "/${var.cluster_name}/kubeadm/controlplane_join_command"
  description = "kubeadm control plane node join command for the ${var.cluster_name} cluster"
  type        = "SecureString"
  value       = "__EMPTY__"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "worker_join_command" {
  name        = "/${var.cluster_name}/kubeadm/worker_join_command"
  description = "kubeadm worker node join command for the ${var.cluster_name} cluster"
  type        = "SecureString"
  value       = "__EMPTY__"
  lifecycle {
    ignore_changes = [value]
  }
}
