resource "aws_vpc" "kubeadm_k8s_test_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags = {
    Name = "kubeadm_k8s_test_vpc"
  }
}

resource "aws_subnet" "kubeadm_k8s_test_public_net" {
  vpc_id                  = aws_vpc.kubeadm_k8s_test_vpc.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "kubeadm_k8s_test_public_net"
  }
}

resource "aws_internet_gateway" "kubeadm_k8s_test_igw" {
  vpc_id = aws_vpc.kubeadm_k8s_test_vpc.id
  tags = {
    Name = "kubeadm_k8s_test_igw"
  }
}

resource "aws_route_table" "kubeadm_k8s_test_public_net_rt" {
  vpc_id = aws_vpc.kubeadm_k8s_test_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kubeadm_k8s_test_igw.id
  }
  tags = {
    Name = "kubeadm_k8s_test_public_net_rt"
  }
}

resource "aws_route_table_association" "kubeadm_k8s_test_public_net_rt_association" {
  subnet_id      = aws_subnet.kubeadm_k8s_test_public_net.id
  route_table_id = aws_route_table.kubeadm_k8s_test_public_net_rt.id
}
