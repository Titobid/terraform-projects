locals {
  double_numbers = [for num in var.numbers_list : num * 2]
  even_number    = [for num in var.numbers_list : num if num % 2 == 0]
  firtstname     = [for name in var.object_list : name.firstname]
  fullname       = [for name in var.object_list : "${name.firstname} ${name.lastname}"]
  doubles_map    = { for key, value in var.numbers_map : key => value * 2 }
  even_map       = { for key, value in var.numbers_map : key => value if value % 2 == 0 }
  users_map      = { for user in var.users : user.username => user.role... }               ## This converts the list of user objects into a map where the username is the key and the role is the value
  users_map2     = { for username, role in local.users_map : username => {role = role }}## This converts the users_map into a map of maps, where each username maps to another map containing the role
  usernames_from_map = [for username, role in local.users_map : username] ## This creates a new map that only contains the usernames as keys, effectively discarding the role information
}
output "double_numbers" {
  value = local.double_numbers
}

output "even_numbers" {
  value = local.even_number
}
output "first_name" {
  value = local.firtstname
}

output "fullname" {
  value = local.fullname
}

output "doubles_map" {
  value = local.doubles_map
}

output "even_map" {
  value = local.even_map
}

output "user_map" {
  value = local.users_map
}

output "user_map2" {
  value = local.users_map2
}

output "user_to_output" {
    value = local.users_map2[var.user_to_output].role
}

output "usernames_from_map" {
  value = local.usernames_from_map
}