module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0.1"

  name   = "test-sg-https"
  vpc_id = module.vpc.vpc_id
  tags   = local.tags
}

resource "aws_autoscaling_group" "test" {
  name_prefix          = "test-alb"
  max_size             = 1
  min_size             = 1
  launch_configuration = aws_launch_configuration.as_conf.name
  health_check_type    = "EC2"
  target_group_arns    = module.alb.target_group_arns
  force_delete         = true
  vpc_zone_identifier  = module.vpc.public_subnets
}
resource "aws_launch_configuration" "test" {
  name_prefix   = "test_lc"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  user_data_base64=${data.template_file.launch_user_data.rendered}"
}

resource "aws_launch_configuration" "as_conf" {
  name          = "web_config"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
}
resource "aws_s3_bucket" "log_bucket" {
  bucket        = local.log_bucket_name
  policy        = data.aws_iam_policy_document.bucket_policy.json
  force_destroy = true
  tags          = local.tags

  lifecycle_rule {
    id      = "log-expiration"
    enabled = "true"

    expiration {
      days = "7"
    }
  }
}



module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 4.0"
  load_balancer_name       = "test-alb-${random_string.suffix.result}"
  security_groups          = [module.security_group.this_security_group_id]
  logging_enabled          = true
  log_bucket_name          = aws_s3_bucket.log_bucket.id
  log_location_prefix      = var.log_location_prefix
  subnets                  = module.vpc.public_subnets
  tags                     = local.tags
  vpc_id                   = module.vpc.vpc_id
  http_tcp_listeners       = local.http_tcp_listeners
  http_tcp_listeners_count = local.http_tcp_listeners_count
  target_groups            = local.target_groups
  target_groups_count      = local.target_groups_count
}

#module "db" {
#  source = "terraform-aws-modules/rds/aws"
#
#  identifier = "demodb-postgres"
#
#  engine            = "postgres"
#  engine_version    = "9.6.9"
#  instance_class    = "db.t2.large"
#  allocated_storage = 5
#  storage_encrypted = false
#
#  # kms_key_id        = "arm:aws:kms:<region>:<account id>:key/<kms key id>"
#  name = "demodb"
#
#  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
#  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
#  # user cannot be used as it is a reserved word used by the engine"
#  username = "demouser"
#
#  password = "${var.databasepassword}"
#  port     = "5432"
#
#  vpc_security_group_ids = ["${module.vpc.default_security_group_id}"]
#
#  maintenance_window = "Mon:00:00-Mon:03:00"
#  backup_window      = "03:00-06:00"
#
#  # disable backups to create DB faster
#  backup_retention_period = 0
#
#  tags = {
#    Owner       = "user"
#    Environment = "dev"
#  }
#
#  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
#
#  # DB subnet group
#  subnet_ids = "${module.vpc.private_subnets}"
#  # DB parameter group
#  family = "postgres9.6"
#
#  # DB option group
#  major_engine_version = "9.6"
#
#  # Snapshot name upon DB deletion
#  final_snapshot_identifier = "demodb"
#
#  # Database Deletion Protection
#  deletion_protection = false
#}
