output "region" {
  value = var.region
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "project_name" {
  value = var.project_name
}

output "subnet_az1_id" {
  value = aws_subnet.public_subnet_az1.id
}

output "subnet_az2_id" {
  value = aws_subnet.public_subnet_az2.id
}