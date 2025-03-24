# Terraform AWS Kubeadm K8s

This module provisions [Kubernetes](https://kubernetes.io) clusters on [AWS EC2](https://) instances using [Kubeadm]() with a [stacked etcd topology](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/ha-topology/#stacked-etcd-topology).

## How it works

1. Each node is created with a [user-data script](https://cloudinit.readthedocs.io/en/latest/explanation/format.html#id2) that runs at first boot.
2. The script prepares each node with prerequisite configurations and packages.
3. `kubeadm init` is run on the first control-plane node to initialize the Kubernetes cluster.
4. The resulting `kubeadm join` commands are copied to an S3 bucket.
5. All other nodes download the `kubeadm join` command from the S3 bucket and join the cluster.
6. The cluster admin can then manage the cluster using `kubectl`, etc. via the first control-plane node.

> [!IMPORTANT]  
> No [CNI plugin](https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/network-plugins/) is installed by this module. You will need to install one yourself before running workloads.
 
> [!WARNING]  
> For now, the API server endpoint is configured with the IP address of the first control-plane node. While suitable for testing, it does not provide high-availability.

## Example Usage

```terraform
module "mycluster" {
  source                  = "bcbrookman/kubeadm-k8s/aws"
  cluster_name            = "mycluster"
  controlplane_node_count = 1
  worker_node_count       = 3
  subnet_id               = aws_subnet.mysubnet.id
  ssh_key_name            = aws_key_pair.mykeypair.key_name
}
```
