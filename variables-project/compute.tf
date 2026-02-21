locals {
  common_tags = {
    project       = "terraform-projects"
    project_owner = "Titobioluwa"
    cost_center   = "prod-terraform-projects"
    managed_by    = "terraform"
  }
}
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

output "ubuntu-ami-id" {
  value = data.aws_ami.ubuntu.id
}

resource "aws_instance" "ubuntu-instance" {
  tags          = local.common_tags
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.ec2_instance_type
  root_block_device {
    delete_on_termination = true
    volume_type           = var.ec2_volume_config.type
    volume_size           = var.ec2_volume_config.size
  }
}

