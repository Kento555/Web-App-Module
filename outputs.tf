
output "public_ips" {
  description = "Public IP addresses of the EC2 instances from the web_app module"
  value       = module.web_app.public_ips
}



