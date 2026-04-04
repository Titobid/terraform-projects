locals {
  allowed_instance_types = ["t2.micro", "t2.small", "t3.micro"]
  project_name           = "object-validations-postcondition"
}

data "aws_ami" "Ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "default" {
  default = true
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "availability_zone" {
  type    = string
  default = "ca-central-1a"
}

resource "aws_instance" "ubuntu" {
  ami           = data.aws_ami.Ubuntu.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.postcondition.id

  lifecycle {
    create_before_destroy = true
    postcondition {
      condition     = contains(local.allowed_instance_types, self.instance_type)
      error_message = "Instance type is not allowed. Please choose from ${join( ", ", local.allowed_instance_types)}."
    }
  }

  tags = {
    name = "${local.project_name}-instance"
  }
}

resource "aws_subnet" "postcondition" {
  availability_zone = var.availability_zone
  vpc_id            = data.aws_vpc.default.id
  cidr_block        = "172.31.128.0/24"

  lifecycle {
    postcondition {
      condition = contains(data.aws_availability_zones.available.names , self.availability_zone)
      error_message = "Availability zone is not available. Please choose from ${join(", ", data.aws_availability_zones.available.names)}."
    }
  }
  tags = {
    name = "${local.project_name}-subnet"
  }
}