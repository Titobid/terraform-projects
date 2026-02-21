variable "aws_region" {
  description = "region to deploy resources in"
  type        = string
  default     = "us-west-2"
}

variable "ec2_instance_type" {
  description = "type of ec2 instance"
  type        = string
  default     = "t2.micro"
  validation {
    condition     = var.ec2_instance_type == "t2.micro" || var.ec2_instance_type == "t3.micro"
    error_message = "ec2_instance_type must be either t2.micro or t3.micro"
  }
}

variable "ec2_volume_config" {
  description = "size and type of ec2 block volume"
  type = object({
    type = string
    size = number
  })
  default = {
    type = "gp2"
    size = 10
  }
}
