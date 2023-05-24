provider "aws" {
  region = "us-east-2"
}

terraform {
  backend "s3" {
    bucket = "arq.state"
    key    = "arc.tfstate"
    region = "us-east-2"
  }
}
resource "aws_instance" "webserver" {
  ami                         = "ami-024e6efaf93d85776"
  instance_type               = "t3.small"
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ssh.key_name
  vpc_security_group_ids = [
    aws_security_group.webserver.id
  ]
  user_data = file("master_user_data.bash")

  subnet_id = "subnet-36d5f65e"

  tags = {
    Name = "ARQ Web Server"
  }
}

resource "aws_security_group" "webserver" {
  name        = "Arq"
  description = "Allow Web Server inbound traffic"
  vpc_id      = "vpc-db003bb3"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["82.12.162.67/32"]
  }

  ingress {
    description = "HTTP Traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Arq Web"
  }
}

resource "aws_eip" "arq" {
  instance = aws_instance.webserver.id
  vpc      = true
}

output "elastic_ip_addr" {
  value = aws_eip.arq.address
}