data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "ubuntu-us-east" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  provider = aws.us-east

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
output "ubuntu-ami-value" {
  value = data.aws_ami.ubuntu.id
}
output "ubuntu-us-east-ami-value" {
  value = data.aws_ami.ubuntu-us-east.id
}

resource "aws_instance" "ubuntu-instance" {
    ami           = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
  root_block_device {
    volume_size = 10
    volume_type = "gp3"
    delete_on_termination = true
  }
}