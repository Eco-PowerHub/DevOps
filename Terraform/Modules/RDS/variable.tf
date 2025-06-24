variable "instance_class" {
  default = "db.t3.micro"
}

variable "db_name" {}
variable "username" {}
variable "password" {
  sensitive = true
}
