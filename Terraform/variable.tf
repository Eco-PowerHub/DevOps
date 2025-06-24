variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "az" {
  default = "us-east-1a"
}

variable "bucket_name" {
  default = "my-terraform-bucket-123"
}

variable "table_name" {
  default = "terraform-locks"
}

variable "instance_class" {
  default = "db.t3.micro"
}

variable "db_name" {
  default = "mydb"
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  default     = "MySecurePass123!"
  sensitive   = true
}

variable "ami_id" {
  default = "ami-0c55b159cbfafe1f0" # AMI for Amazon Linux 2
}

variable "instance_type" {
  default = "t2.micro"
}

variable "cluster_name" {
  default = "my-eks-cluster"
}
