locals {
  public_subnet  = { for key, config in var.subnet_configs : key => config if config.public }
  private_subnet = { for key, config in var.subnet_configs : key => config if !config.public }
}

data "aws_availability_zones" "azs" {
  state = "available"
}

resource "aws_vpc" "this" {
  cidr_block = var.vpc_config.cidr_block
  tags = {
    Name = var.vpc_config.name
  }
}

resource "aws_subnet" "this" {
  for_each          = var.subnet_configs
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  tags = {
    Name = each.value.name
  }
  lifecycle {
    precondition {
      condition     = contains(data.aws_availability_zones.azs.names, each.value.availability_zone)
      error_message = <<EOT
    the availability_zone provided "${each.value.availability_zone}" for subnet "${each.key}" is invalid, the value can be one of the following: ${join(",", data.aws_availability_zones.azs.names)}
EOT
    }
  }
}

resource "aws_internet_gateway" "this" {
  count  = length(local.public_subnet) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id
}

resource "aws_route_table" "public_rtb" {
  count  = length(local.public_subnet) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
  }
}

resource "aws_route_table_association" "public_rtb" {
  for_each       = local.public_subnet
  route_table_id = aws_route_table.public_rtb[0].id
  subnet_id      = aws_subnet.this[each.key].id
}