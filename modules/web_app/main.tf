locals {
 selected_subnet_ids = var.public_subnet ? data.aws_subnets.public.ids : data.aws_subnets.private.ids
}


resource "aws_instance" "web_app" {
 count = var.instance_count


 ami                    = data.aws_ami.latest_amazon_linux.id # Alternative to use valid AMI: "ami-0df8c184d5f6ae949"
 instance_type          = var.instance_type
 subnet_id              = local.selected_subnet_ids[count.index % length(local.selected_subnet_ids)]
#  subnet_id              = data.aws_subnets.public.ids[count.index % length(data.aws_subnets.public.ids)]   # This is initial at Public Subnet
 vpc_security_group_ids = [aws_security_group.web_app.id]
 user_data = templatefile("${path.module}/init-script.sh", {
   file_content = "webapp-#${count.index}"
 })


 associate_public_ip_address = true
 tags = {
   Name = "${var.name_prefix}-webapp-${count.index}"
 }
}

resource "aws_security_group" "web_app" {
 name_prefix = "${var.name_prefix}-webapp"
 description = "Allow traffic to webapp"
 vpc_id      = data.aws_vpc.selected.id


 ingress {
   from_port        = 80
   to_port          = 80
   protocol         = "tcp"
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
 }


 egress {
   from_port        = 0
   to_port          = 0
   protocol         = "-1"
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
 }


 lifecycle {
   create_before_destroy = true
 }
}

resource "aws_lb_target_group" "web_app" {
 name     = "${var.name_prefix}-webapp"
 port     = 80
 protocol = "HTTP"
 vpc_id   = data.aws_vpc.selected.id


 health_check {
   port     = 80
   protocol = "HTTP"
   timeout  = 3
   interval = 5
 }
}


# resource "aws_lb_target_group_attachment" "web_app" {   # Count paratmeter not define
#  target_group_arn = aws_lb_target_group.web_app.arn
#  target_id        = aws_instance.web_app.id   
#  port             = 80
# }

# resource "aws_lb_target_group_attachment" "web_app" {                                             
#   for_each          = { for idx, instance in aws_instance.web_app : idx => instance.id }
#   target_group_arn  = aws_lb_target_group.web_app.arn
#   target_id         = each.value
#   port              = 80
# }



# resource "aws_lb_listener_rule" "web_app" {
#  listener_arn = var.alb_listener_arn
#  priority     = 100


#  action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.web_app.arn
#  }


#  condition {
#    path_pattern {
#      values = ["/myname"] 
#    }
#  }
# }

resource "aws_lb" "web_app" {
  name               = "${var.name_prefix}-webapp-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_app.id]
  subnets            = local.selected_subnet_ids
  enable_deletion_protection = false

  tags = {
    Name = "${var.name_prefix}-webapp-alb"
  }
}
resource "aws_lb_listener" "web_app" {
  load_balancer_arn = aws_lb.web_app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.web_app.arn
  }

  
}


