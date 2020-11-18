# Create private sub
resource "aws_subnet" "subprivate" {
  vpc_id     = var.vpc_id
  cidr_block = "117.0.2.0/24"
  availability_zone = "eu-west-1b"
  tags = {
    Name = "${var.name}sub.private"
  }
}


# Create NACL for private subnet
resource "aws_network_acl" "nacl_private" {
  vpc_id = var.vpc_id

    ingress {
      rule_no     = 100
      from_port   = 27017
      to_port     = 27017
      protocol    = "tcp"
      #cidr_block  = aws_subnet.subpublic.cidr_block
      cidr_block = var.subpublic_cidr_block
      action      = "allow"
    }

    egress {
      rule_no     = 100
      action      = "allow"
      protocol    = "tcp"
      from_port   = 1024
      to_port     = 65535
      cidr_block = var.subpublic_cidr_block
      #cidr_blocks = aws_subnet.subpublic.cidr_block
    }
    subnet_ids = [aws_subnet.subprivate.id]

    tags = {
      Name = "${var.name}nacls.private"
    }
}

# Creating security group for db
resource "aws_security_group" "sgdb" {
  name        = "db-sg"
  description = "Allow http and https traffic"
  #vpc_id      = aws_vpc.mainvpc.id
  vpc_id = var.vpc_id

  ingress {
    description = "connection from DB"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    # cidr_blocks = ["17.0.1.0/24"]
    security_groups = [var.security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}sg.db"
  }
}

# Creating an ec2 instance for db
resource "aws_instance" "db" {
  ami           = var.ami-db
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subprivate.id
  vpc_security_group_ids = [aws_security_group.sgdb.id]
  key_name = var.ssh_key_var
  tags = {
    Name = "${var.name}tf.db"
  }
}
