variable "users" {
  type = list(object({
    username = string
    role     = string
  }))
}
variable "numbers_map" {
  type = map(number)
}

variable "numbers_list" {
  type = list(number)
}

variable "object_list" {
  type = list(object({
    firstname = string
    lastname  = string
  }))
}

variable "user_to_output"{
    type = string
}