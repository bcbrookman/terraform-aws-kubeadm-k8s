output "apiserver_lb_dns_name" {
  description = "The DNS name generated for the load balanced API server endpoint."
  value       = aws_lb.apiserver.dns_name
}
