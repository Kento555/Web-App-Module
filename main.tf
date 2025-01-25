module "web_app" {
 source = "./modules/web_app"


 name_prefix = "WS" 


 instance_type  = "t2.micro"
 instance_count = 2


 vpc_id        = "vpc-012814271f30b4442" # ce9-coaching-shared-vpc
 public_subnet = false                    # Set to false for private subnet deployment

 alb_listener_arn = "..."

}
