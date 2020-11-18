# Create public sub
resource "aws_subnet" "sub_public_again" {
  vpc_id     = var.vpc_id
  cidr_block = "117.0.1.0/24"
  availability_zone = "eu-west-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}sub.public"
  }
  # lifecycle {
  #   create_before_destroy = true
  # }
}

# Creating security group for webapp
resource "aws_security_group" "sg_app" {
  name        = "sgappsvb"
  description = "Allow http and https traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "https from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "httpx from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
   description = "httpx from VPC"
   from_port   = 3000
   to_port     = 3000
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }

  ingress {
    description = "httpx from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my-ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}sg.app.2"
  }
  # lifecycle {
  #   create_before_destroy = true
  # }
}

# Creating NACls for public sub
resource "aws_network_acl" "naclpublic" {
  vpc_id = var.vpc_id

  # traffic on por 80 allow
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  # traffic on por EPHEMERAL PORTS allow

  egress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 130
    action     = "allow"
    cidr_block = var.my-ip
    from_port  = 22
    to_port    = 22
  }
  egress {
    protocol   = "tcp"
    rule_no    = 130
    action     = "allow"
    cidr_block = var.my-ip
    from_port  = 0
    to_port    = 65535
  }

  subnet_ids = [aws_subnet.sub_public_again.id]

  tags = {
    Name = "${var.name}nacls.public"
  }
}

# Creating a route table
resource "aws_route_table" "routepublic" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway_id
  }
  tags = {
    Name = "${var.name}route.public"
  }
}

# Route table associations
resource "aws_route_table_association" "routeapp" {
  subnet_id = aws_subnet.sub_public_again.id
  route_table_id = aws_route_table.routepublic.id
}


# load init script to be used
data "template_file" "initapp" {
  template = file("./scripts/app/init.sh.tpl")
  vars = {
    db_host = "${var.db_private_ip}"
  }
}

# Creating an ec2 instance IMAGE with our app
resource "aws_instance" "Web" {
  ami           =  var.ami-web
  instance_type = "t2.micro"
  subnet_id = aws_subnet.sub_public_again.id
  key_name = var.ssh_key_var
  vpc_security_group_ids = [aws_security_group.sg_app.id]
  associate_public_ip_address = true
  user_data = data.template_file.initapp.rendered
  tags = {
    Name = "${var.name}tf.app"
  }
}
