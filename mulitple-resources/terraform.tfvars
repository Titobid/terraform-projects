subnet_config = {
  "default" = {
    cidr_block = "10.0.0.0/24"
  },
  "subnet-1" = {
    cidr_block = "10.0.1.0/24"
  },
  "subnet-2" = {
    cidr_block = "10.0.2.0/24"
  }
}

ec2_instance_config_list = [
  # {
  #   instance_type = "t2.micro"
  #   ami           = "ubuntu"
  # },
  # {
  #   instance_type = "t2.micro"
  #   ami           = "nginx"
  # }
]

ec2_instance_config_map = {
  ubuntu_1 = {
    instance_type = "t2.micro"
    ami           = "ubuntu"
    subnet_name   = "subnet-1"
  },
  nginx_1 = {
    instance_type = "t2.micro"
    ami           = "nginx"
    subnet_name   = "subnet-2"
  },
  nginx_2 = {
    instance_type = "t2.micro"
    ami           = "nginx"
    subnet_name   = "default"
  },
  ubuntu_2 = {
    instance_type = "t2.micro"
    ami           = "ubuntu"
    subnet_name   = "subnet-1"
  }
}