variable "vpc_config" {
  type = object({
    cidr_block = string
    name       = string
  })

  validation {
    condition     = can(cidrnetmask(var.vpc_config.cidr_block))
    error_message = "Please enter a valid cidr_block for the VPC"
  }
}

variable "subnet_configs" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
    name              = string
    public            = optional(bool, false)
  }))

  validation {
    condition     = alltrue([for config in values(var.subnet_configs) : can(cidrnetmask(config.cidr_block))])
    error_message = "Please enter a valid cidr_block for the Subnet"
  }
}