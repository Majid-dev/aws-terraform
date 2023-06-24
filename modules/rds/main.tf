resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db_subnet"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "primary" {
  identifier              = var.db_instance_identifier
  engine                  = "mysql"
  engine_version          = "8.0"
  backup_retention_period = 7
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  skip_final_snapshot     = true
  vpc_security_group_ids  = var.vpc_security_group_ids
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name

  tags = {
    Name = "PrimaryDBInstance"
  }
}

resource "aws_db_instance" "read_replica" {
  count                   = var.create_read_replica ? 1 : 0
  identifier              = "${var.db_instance_identifier}-read-replica"
  backup_retention_period = 7
  instance_class          = var.instance_class
  vpc_security_group_ids  = var.vpc_security_group_ids
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  replicate_source_db     = aws_db_instance.primary.identifier

  tags = {
    Name = "ReadReplicaDBInstance"
  }
}