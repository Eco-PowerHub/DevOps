output "vpc_id" {
  value = module.network.vpc_id
}

output "subnet_id" {
  value = module.network.subnet_id
}

output "s3_bucket" {
  value = module.s3.bucket_name
}

output "dynamodb_table" {
  value = module.dynamodb.table_name
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}

output "ec2_instance_id" {
  value = module.ec2.instance_id
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}
