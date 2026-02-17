data "aws_ami" "ubuntu" {
    most_recent = true
    owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-20.04-amd64-server-*"]
  }
  filter {
  name = "virtualization-type"
  values = ["hvm"]
}
}

output "ubuntu-ami-id" {
  value = data.aws_ami.ubuntu.id
}

resource "aws_instance" "ubuntu-instance" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  root_block_device {
    delete_on_termination = true
    volume_type = "gp2"
    volume_size = 10
}
}

