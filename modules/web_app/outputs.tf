output "public_ips" {
  description = "Public IP addresses of the EC2 instances"
  value       = aws_instance.web_app[*].public_ip
}

output "alb_listener_arn" {
  value = var.alb_listener_arn
}

output "alb_dns_name" {
  value = aws_lb.web_app.dns_name
  description = "The DNS name of the load balancer (URL of the application)"
}


output "application_url" {
  value = "http://${aws_lb.web_app.dns_name}/myname"
  description = "URL to access the deployed application"
}

