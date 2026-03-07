variable "subnet_config" {
  description = "Configuration for subnets"
  type = map(object({
    cidr_block = string
  }))
  validation {
    condition = alltrue([for config in values(var.subnet_config) : can(cidrnetmask(config.cidr_block))])
    error_message = "At least one of the cidr_block entered is invalid"
  }
}

variable "ec2_instance_config_list" {
  type = list(object({
    instance_type = string
    ami           = string
    subnet_name   = optional(string, "default")
  }))
  validation {
    condition     = alltrue([for config in var.ec2_instance_config_list : contains(["ubuntu", "nginx"], config.ami)])
    error_message = "only supports 'ubuntu' and 'nginx' as AMI values"
  }
  validation {
    condition     = alltrue([for config in var.ec2_instance_config_list : contains(["t2.micro"], config.instance_type)])
    error_message = "only supports 't2.micro' as instance type"
  }
}

variable "ec2_instance_config_map" {
  type = map(object({
    instance_type = string
    ami           = string
    subnet_name   = optional(string, "default")
  }))
  validation {
    condition     = alltrue([for config in values(var.ec2_instance_config_map) : contains(["ubuntu", "nginx"], config.ami)])
    error_message = "only supports 'ubuntu' and 'nginx' as AMI values"
  }
  validation {
    condition     = alltrue([for config in values(var.ec2_instance_config_map) : contains(["t2.micro"], config.instance_type)])
    error_message = "only supports 't2.micro' as instance type"
  }
}