variable "subnet_count" {
  description = "Number of subnets to create"
  type        = number
  default     = 2
}

variable "ec2_instance-count" {
  type = number
  default = 4
}