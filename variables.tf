variable "apiserver_crosszone_lb_enabled" {
  description = "Whether cross-zone load balancing is enabled on the apiserver load balancer."
  type        = bool
  default     = false
  nullable    = false
}

variable "apiserver_dns" {
  description = "Overrides the DNS name used in kubeadm init/join commands. Use when [customizing the apiserver DNS name](https://registry.terraform.io/modules/bcbrookman/kubeadm-k8s/aws/auto#customizing-the-api-server-dns-name)."
  type        = string
  default     = "CLUSTERNAME-RANDOM.elb.REGION.amazonaws.com"
  nullable    = false

  validation {
    condition = can(regex("^[A-Za-z0-9]([A-Za-z0-9](-[A-Za-z0-9]){0,61})*(\\.[A-Za-z0-9]([A-Za-z0-9](-[A-Za-z0-9]){0,61})*.)*\\.*$", var.apiserver_dns))
    error_message = "The DNS name must be a valid DNS name like 'example.com' or 'sub.example.org'."
  }
}

variable "apiserver_port" {
  description = "The TCP listening port used by the apiserver local instances and load balancer."
  type        = number
  default     = 6443
  nullable    = false

  validation {
    condition     = var.apiserver_port >= 1 && var.apiserver_port <= 65535
    error_message = "Must be a port number between 1 and 65535."
  }
}

variable "cluster_name" {
  description = "The name of the cluster. Used in naming and labeling resources. Must be between 1 and 17 characters."
  type        = string
  nullable    = false

  validation {
    condition     = length(var.cluster_name) >= 1 && length(var.cluster_name) <= 17
    error_message = "Must be between 1 and 17 characters."
  }
}

variable "containerd_version" {
  description = "The version of containerd to *initially* install on nodes. Changing this variable after instance creation will **NOT** upgrade/downgrade containerd. `\"auto\"` means the package manager should decide."
  type        = string
  default     = "auto"
  nullable    = false

  validation {
    condition = var.containerd_version == "auto" || can(regex(
      "^\\d+\\.\\d+\\.\\d+(-[0-9A-Za-z-.]+)?(\\+[0-9A-Za-z-.]+)?$",
      var.containerd_version
    ))
    error_message = "Must follow semantic versioning (e.g., 1.6.20, 1.6.20-beta.1, etc.)."
  }
}

variable "controlplane_node_ami_id" {
  description = "The AMI ID used to provision control-plane nodes. `\"auto\"` selects a Debian AMI."
  type        = string
  default     = "auto"
  nullable    = false
}

variable "controlplane_node_count" {
  description = "The number of control-plane nodes to provision. Must be 1 or more."
  type        = number
  default     = 1
  nullable    = false

  validation {
    condition     = floor(var.controlplane_node_count) == var.controlplane_node_count && var.controlplane_node_count > 0
    error_message = "Must be an integer greater than 0."
  }
}

variable "controlplane_node_instance_type" {
  description = "The instance type used to provision control-plane nodes (e.g. t2.micro, m5.large, etc.). Review the basic [node requirements](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#before-you-begin)."
  type        = string
  default     = "t3.small"
  nullable    = false
}

variable "kubernetes_version" {
  description = "The version of Kubernetes to *initially* install on nodes. Changing this variable after instance creation will **NOT** upgrade/downgrade Kubernetes. `\"auto\"` means the package manager should decide."
  type        = string
  default     = "auto"
  nullable    = false

  validation {
    condition = var.kubernetes_version == "auto" || can(regex(
      "^\\d+\\.\\d+\\.\\d+(-[0-9A-Za-z-.]+)?(\\+[0-9A-Za-z-.]+)?$",
      var.kubernetes_version
    ))
    error_message = "Must follow semantic versioning (e.g., 1.31.0, 1.31.0-beta.1, etc.)."
  }
}

variable "ssh_key_name" {
  description = "The name of an existing Key Pair for connecting to instances. Can be set with [`aws_key_pair.<name>.key_name`](https://registry.terraform.io/providers/hashicorp/aws/auto/docs/resources/key_pair). `\"none\"` means no Key Pair will be attached to the instances."
  type        = string
  default     = "none"
  nullable    = false
}

variable "subnet_id" {
  description = "The subnet ID to create the cluster nodes in. Can be set with [`aws_key_pair.<name>.key_name`](https://registry.terraform.io/providers/hashicorp/aws/auto/docs/resources/key_pair)."
  type        = string
  nullable    = false
}

variable "worker_node_ami_id" {
  description = "The AMI ID used to provision worker nodes. `\"auto\"` selects a Debian AMI."
  type        = string
  nullable    = false
  default     = "auto"
}

variable "worker_node_count" {
  description = "The number of worker nodes to provision. Must be 0 or more."
  type        = number
  default     = 1
  nullable    = false

  validation {
    condition     = floor(var.worker_node_count) == var.worker_node_count && var.worker_node_count >= 0
    error_message = "Must be an integer greater than or equal to 0."
  }
}

variable "worker_node_instance_type" {
  description = "The instance type used to provision worker nodes (e.g. t2.micro, m5.large, etc.)."
  type        = string
  default     = "t3.small"
  nullable    = false

  validation {
    condition     = can(regex("^[a-z0-9]+\\.[a-z0-9]+$", var.worker_node_instance_type))
    error_message = "Must be an instance type in the format t2.micro, m5.large, etc."
  }
}
