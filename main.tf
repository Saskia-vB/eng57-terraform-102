provider "aws" {
  region = "eu-west-1"
}

# Creating a vpc
resource "aws_vpc" "mainvpc" {
  cidr_block = "117.0.0.0/16"
  tags = {

    Name = "${var.name}tf.vpc"
  }
}

# Create an igw
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.mainvpc.id
  tags = {
    Name = "${var.name}igw"
  }
}

# #load balancer subnet
# resource "aws_subnet" "sub_lb" {
#   vpc_id     = aws_vpc.mainvpc.id
#   cidr_block = "117.0.3.0/24"
#   availability_zone = "eu-west-1a"
#   map_public_ip_on_launch = true
#   tags = {
#     Name = "${var.name}sub.public"
#   }
# }




# load balancer SG
# resource "aws_security_group" "sg_lb" {
#   name        = "lb-sg"
#   description = "load balancer security group"
#   #vpc_id      = aws_vpc.mainvpc.id
#   vpc_id = var.vpc_id
#
#   ingress {
#     description = "connection from HTTPS"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     description = "connection from HTTP"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     description = "port 22"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = [var.my-ip]
#   }
#
#   ingress {
#     description = "ephemeral ports"
#     from_port   = 1064
#     to_port     = 35535
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     description = "mongodb"
#     from_port   = 27017
#     to_port     = 27017
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
#
# # load balancers
# resource "aws_lb" "load_balancer" {
#   name = "En57-Saskia-tf-lb"
#   load_balancer_type = "network"
#   #security_groups    = [aws_security_group.sg_lb.id]
#   subnets            = [module.app_tier.subpublic_id]
#   #, aws_subnet.sub_lb.id]
#   #subnets            = [aws_subnet.sub_lb.id]
#   tags = {
#     Name = "Eng57-Saskia-lb-tf"
#   }
# }

# listener
# resource "aws_lb_listener" "front_end" {
#   load_balancer_arn = aws_lb.load_balancer.arn
#   port              = "443"
#   protocol          = "HTTPS"
#
#   default_action {
#     type = "forward"
#     target_group_arn = aws_lb_target_group.instance_target_group.arn
#   }
# }

# target group
# resource "aws_lb_target_group" "instance_target_group" {
#   name = "svb-instance-target-group"
#   port = 80
#   protocol = "HTTP"
#   vpc_id = var.vpc_id
#
#   stickiness {
#     enabled = false
#     type = "lb_cookie"
#   }
# }

# calling our module for app_tier
module "app_tier" {
  source = "./modules/app_tier"
  vpc_id = aws_vpc.mainvpc.id
  name = var.name
  my-ip = var.my-ip
  internet_gateway_id = aws_internet_gateway.gw.id
  #db_private_ip = aws_instance.db.private_ip
  db_private_ip = module.db_tier.db_private_ip
  ami-web = var.ami-web
  ssh_key_var = var.ssh_key
}

# calling module for db
module "db_tier" {
  source = "./modules/db_tier"
  vpc_id = aws_vpc.mainvpc.id
  name = var.name
  my-ip = var.my-ip
  internet_gateway_id = aws_internet_gateway.gw.id
  #db_private_ip = aws_instance.db.private_ip
  ami-db = var.ami-db
  ami-web = var.ami-web
  ssh_key_var = var.ssh_key
  subpublic_cidr_block = module.app_tier.subpublic_cidr_block
  security_group_id = module.app_tier.security_group_id
}




#resource "aws_placement_group" ""
