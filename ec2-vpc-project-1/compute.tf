resource "aws_instance" "web" {
  ami                         = "ami-0f8f81db908241ec9"
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.public_http_traffic.id]
  tags = merge(local.common_tags, {
    Name = "06-resource-ec2"
  })
  root_block_device {
    volume_size           = 1026
    volume_type           = "gp2"
    delete_on_termination = true
  }
}

resource "aws_security_group" "public_http_traffic" {
  description = "SECURITY GROUP ALLOWING TRAFFIC FROM PORT 80 AND 443"
  vpc_id      = aws_vpc.main.id
  name        = "public-http-traffic"
  tags = merge(local.common_tags, {
    Name = "06-resource-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.public_http_traffic.id
  cidr_ipv4         = "0.0.0.0/0"
  description       = "allow http from port 80"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.public_http_traffic.id
  cidr_ipv4         = "0.0.0.0/0"
  description       = "allow https from port 443"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}