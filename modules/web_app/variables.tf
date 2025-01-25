variable "name_prefix" {
 description = "Name prefix for application"
 type        = string
}


variable "instance_type" {
 description = "Instance type of ec2"
 type        = string
 default     = "t2.micro"
}


variable "instance_count" {
 description = "Count of ec2 instance"
 type        = number
 default     = 3
}


variable "vpc_id" {
 description = "Virtual private cloud id"
 type        = string
}


variable "public_subnet" {
 description = "Choice of deploying to public or private subnet"
 type        = bool
 default     = false
}

# Ensure that the alb_listener_arn variable contains a valid 
# Application Load Balancer (ALB) listener ARN. It should look something like:
# arn:aws:elasticloadbalancing:region:account-id:listener/app/load-balancer-name/load-balancer-id/listener-id

variable "alb_listener_arn" {
 description = "ALB listener Arn"
 type        = string
 default     = "arn:aws:elasticloadbalancing:us-east-1:255945442255:listener/app/Shared-ALB/682ae805faa144f9/6661b449d0624b96"
}

