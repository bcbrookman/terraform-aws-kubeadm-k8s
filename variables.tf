variable "apiserver_crosszone_lb" {
  description = "Whether cross-zone load balancing is enabled on the apiserver load balancer."
  type        = bool
  default     = false
}

variable "apiserver_dns" {
  description = "Overrides the DNS name used in kubeadm init/join commands. Use only when [customizing the apiserver DNS name]()."
  type        = string
  default     = "CLUSTERNAME-RANDOM.elb.REGION.amazonaws.com"
}

variable "apiserver_port" {
  description = "The listening port used by the apiserver local instances and load balancer."
  type        = number
  default     = 6443
}

variable "cluster_name" {
  description = "The name of the cluster. Used in naming and labeling resources."
  type        = string
}

variable "containerd_version" {
  description = "The version of containerd to *initially* install on nodes. Changing this variable after instance creation will **NOT** upgrade/downgrade containerd."
  type        = string
  default     = ""
}

variable "controlplane_node_ami_id" {
  description = "The AMI ID used to provision control-plane nodes."
  type        = string
  default     = null
}

variable "controlplane_node_count" {
  description = "The number of control-plane nodes to provision."
  type        = number
  default     = 1
}

variable "controlplane_node_instance_type" {
  description = "The instance type used to provision control-plane nodes (review the basic requirements at https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/provision-cluster-kubeadm/)."
  type        = string
  default     = "t3.small"
}

variable "kubernetes_version" {
  description = "The version of Kubernetes to *initially* intall on nodes. Changing this variable after instance creation will **NOT** upgrade/downgrade Kubernetes."
  type        = string
  default     = ""
}

variable "ssh_key_name" {
  description = "The name of an existing Key Pair for connecting to instances. Often used with [`aws_key_pair.<name>.key_name`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair)."
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "The subnet ID to create the cluster nodes in."
  type        = string
}

variable "worker_node_ami_id" {
  description = "The AMI ID used to provision worker nodes"
  type        = string
  default     = null
}

variable "worker_node_count" {
  description = "The number of worker nodes to provision."
  type        = number
  default     = 1
}

variable "worker_node_instance_type" {
  description = "The instance type used to provision worker nodes."
  type        = string
  default     = "t3.small"
}
