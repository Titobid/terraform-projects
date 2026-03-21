data "aws_availability_zones" "azs" {
  state = "available"
}

module "vpc" {
    source  = "terraform-aws-modules/vpc/aws"
    version = "6.6.0"

    cidr            = "10.0.0.0/16"
    name            = "public-ec2-vpc"
    azs             = data.aws_availability_zones.azs.names
    public_subnets  = ["10.0.1.0/24"]
    private_subnets = ["10.0.128.0/24"]
    
}