provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_vpc" "lt" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "LT"
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.lt.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "lt_public"
  }
}

resource "aws_internet_gateway" "lt" {
  vpc_id = aws_vpc.lt.id

  tags = {
    Name = "lt-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.lt.id

  tags = {
    Name = "public"
  }
}

resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id = aws_route_table.public.id
  gateway_id = aws_internet_gateway.lt.id
}

resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "lt-server" {
  name = "lt-server-sg"
  description = "LT Server Security Group"

  vpc_id = aws_vpc.lt.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lt-server-sg"
  }
}

resource "aws_eip" "lt-ssh" {
  vpc = true

  tags = {
    Name = "lt"
  }
}

resource "aws_eip_association" "lt-ssh" {
  instance_id = aws_instance.lt_ssh.id
  allocation_id = aws_eip.lt-ssh.id
}


resource "aws_key_pair" "lt_secret" {
  key_name = "lt_secret"
  public_key = file("./id_rsa.pub")
}

resource "aws_instance" "lt_ssh" {
  ami = "ami-0e039c7d64008bd84"
  instance_type = "t2.micro"

  key_name = aws_key_pair.lt_secret.key_name

  subnet_id = aws_subnet.public.id
  security_groups = [aws_security_group.lt-server.id]
  tags = {
    Name = "lt_ssh"
  }
}

output "public_ip" {
  value = aws_eip.lt-ssh.public_ip
}