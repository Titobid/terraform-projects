locals {
  output_public_subnet_id = { for key in keys(local.public_subnet) : key => {
    subnet_id         = aws_subnet.this[key].id
    availability_zone = aws_subnet.this[key].availability_zone
  } }
  output_private_subnet_id = { for key in keys(local.private_subnet) : key => {
    subnet_id         = aws_subnet.this[key].id
    availability_zone = aws_subnet.this[key].availability_zone
  } }
}

output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = local.output_public_subnet_id
}

output "private_subnet_ids" {
  value = local.output_private_subnet_id
}