#  AWS kubeadm-k8s Terraform module

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

## Customizing the API server DNS name

The DNS name of the API server load balancer is available as a module output so it can be used in a CNAME record to customize the API server's DNS name.

For example:

```terraform
module "mycluster" {
  source        = "bcbrookman/kubeadm-k8s/aws"
  ...
  apiserver_dns = "mycluster.mydomain.example"
}

resource "aws_route53_record" "mycluster" {
  zone_id = aws_route53_zone.example.zone_id
  name    = "mycluster.mydomain.example"
  type    = "CNAME"
  ttl     = 300
  records = [module.mycluster.apiserver_lb_dns]
}
```
