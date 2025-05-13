run "setup" {
  module {
    source = "./tests/setup"
  }
}

run "inputs_invalid" {
  command = plan

  variables {
    cluster_name                    = "cluster-name-that-is-too-long"
    apiserver_dns                   = "invalid_dns_name.example.com"
    apiserver_port                  = 66443
    containerd_version              = "1620"
    kubernetes_version              = "1310"
    controlplane_node_count         = 0
    controlplane_node_instance_type = "invalid-instance-type"
    worker_node_count               = -1
    worker_node_instance_type       = "invalid-instance-type"
    subnet_id                       = run.setup.kubeadm_k8s_test_subnet_id
  }

  expect_failures = [
    var.cluster_name,
    var.apiserver_dns,
    var.apiserver_port,
    var.containerd_version,
    var.kubernetes_version,
    var.controlplane_node_count,
    var.controlplane_node_instance_type,
    var.worker_node_count,
    var.worker_node_instance_type,
  ]
}

run "inputs_valid" {
  command = plan

  variables {
    cluster_name                    = "my-cluster"
    apiserver_dns                   = "my-cluster.example.com"
    apiserver_port                  = 6443
    containerd_version              = "1.6.20"
    kubernetes_version              = "1.31.0"
    controlplane_node_count         = 1
    controlplane_node_instance_type = "t3.small"
    worker_node_count               = 1
    worker_node_instance_type       = "t3.small"
    subnet_id                       = run.setup.kubeadm_k8s_test_subnet_id
  }
}
