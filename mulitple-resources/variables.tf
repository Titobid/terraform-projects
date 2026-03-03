variable "subnet_count" {
  description = "Number of subnets to create"
  type        = number
  default     = 2
}

variable "ec2_instance_config_list" {
  type = list(object({
    instance_type = string
    ami           = string
  }))
  validation {
    condition = alltrue([for config in var.ec2_instance_config_list : contains(["ubuntu", "nginx"], config.ami)])
    error_message = "only supports 'ubuntu' and 'nginx' as AMI values"
  }
  validation {
    condition = alltrue([for config in var.ec2_instance_config_list : contains(["t2.micro"], config.instance_type)])
    error_message = "only supports 't2.micro' as instance type"
  }
}