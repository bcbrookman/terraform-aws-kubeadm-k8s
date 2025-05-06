data "aws_subnet" "selected" {
  id = var.subnet_id
}

resource "aws_lb" "apiserver" {
  name                             = var.cluster_name
  load_balancer_type               = "network"
  internal                         = true
  enable_cross_zone_load_balancing = var.apiserver_crosszone_lb_enabled

  subnet_mapping {
    subnet_id = var.subnet_id
  }
}

resource "aws_lb_target_group" "apiserver" {
  name        = "${var.cluster_name}-tg"
  port        = var.apiserver_port
  protocol    = "TCP"
  vpc_id      = data.aws_subnet.selected.vpc_id
  target_type = "instance"

  # Mitigate host RPF filtering when src_ip = dest_ip
  preserve_client_ip = false

  depends_on = [
    aws_lb.apiserver
  ]
}

resource "aws_lb_target_group_attachment" "apiserver" {
  for_each = {
    for k, v in module.controlplane_nodes :
    k => v
  }

  target_group_arn = aws_lb_target_group.apiserver.arn
  target_id        = each.value.id
  port             = var.apiserver_port
}

resource "aws_lb_listener" "apiserver" {
  load_balancer_arn = aws_lb.apiserver.arn
  protocol          = "TCP"
  port              = var.apiserver_port

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.apiserver.arn
  }
}
