module "network" {
  source             = "./Modules/Network"
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
}

module "s3" {
  source      = "./Modules/s3"
  bucket_name = var.bucket_name
}

module "dynamodb" {
  source     = "./Modules/DynamoDB"
  table_name = var.table_name
}

module "rds" {
  source         = "./Modules/RDS"
  instance_class = var.instance_class
  db_name        = var.db_name
  username       = var.db_username
  password       = var.db_password
}

module "ec2" {
  source        = "./Modules/EC2"
  ami_id        = var.ami_id
  instance_type = var.instance_type
  subnet_id     = module.network.subnet_id
}

module "eks" {
  source       = "./Modules/EKS"
  cluster_name = var.cluster_name
  subnet_ids   = [module.network.subnet_id]
}
