locals {
  project_name = "VPC and Subnets Module"
}
module "vpc" {
  source = "./modules/networking"
  vpc_config = {
    cidr_block = "10.0.0.0/16"
    name       = "my-vpc"
  }
  subnet_configs = {
    subnet1 = {
      cidr_block        = "10.0.0.0/24"
      availability_zone = "ca-central-1a"
      name              = "my-subnet"
      public            = true
    },
    subnet2 = {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "ca-central-1b"
      name              = "my-subnet-2"
    },
    subnet3 = {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "ca-central-1d"
      name              = "my-subnet-3"
    }
  }
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Owner is Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "ec2_instance" {
  for_each      = module.vpc.public_subnet_ids
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = module.vpc.public_subnet_ids[each.key].subnet_id

  tags = {
    name = local.project_name
  }
}