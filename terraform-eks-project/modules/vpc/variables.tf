variable "vpc_cidr" {}
variable "public_subnets" {
  type = list(string)
}
variable "private_subnets" {
  type = list(string)
}
# variable "security_group_id" {
#   type = string
# } 




