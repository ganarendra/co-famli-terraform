module "tags" {
  source              = "../modules/terraform-aws-tags-0.1"
  agency_name         = var.agency
  project_name        = var.project
  environment_name    = var.environment
  fundingrequest_name = var.fundingrequest
  po_name             = var.po
}

module "kms" {
  source = "../modules/kms.1.0.0"
  tags   = module.tags.common_tags
}

module "vpc" {
  source = "../modules/vpc.1.0.0"

  vpc_id                           = "vpc-0ef11366a98ccedd5"
  hosted_zone_id                   = "Z080899120PPI1XZUCSLS"
  root_domain_name                 = "coawsdev.com"
  workstation_subnets              = ["10.159.162.0/24", "10.159.161.0/24", "18.211.112.60/32"]
  database_subnet_ids              = ["subnet-0385abb94d4fd90dd", "subnet-0ef7b349acb504d5f", "subnet-029e8d9b6b78eb489"]
  web_subnet_ids                   = ["subnet-08a49ed407714f514", "subnet-0e63a33b9e7868bac", "subnet-024c26e86c0fc13ce"]
  app_subnet_ids                   = ["subnet-0692c83098af1580b", "subnet-0c98ad71f462bdc2c", "subnet-01270e52ced4ffcae"]
  deployment_sso_role_name         = "AWSReservedSSO_cdle-famli-infradmin-d_3d39ed56d2b9151a"
  tags                             = module.tags.common_tags
  control_tower_sso_infra_iam_role = "AWSReservedSSO_cdle-famli-infradmin-d_3d39ed56d2b9151a"
  oit_support_role                 = "oit-central-support-d-azdo-iac-tmp-base"
  oit_support_policy               = "oit_infra_d_ssm_and_cloudwatch_policy"
}

module "ecs_core_application" {
  source = "../modules/ecs.1.0.0"

  cluster_name             = "${var.agency}-${var.project}-${var.environment}-db-cluster"
  ports                    = [443, 443, 443, 443, 443, 443, 8000, 8090, 443, 443, 443, 443, 443]
  health_check_protocol    = ["HTTPS", "HTTPS", "HTTPS", "HTTPS", "HTTPS", "HTTPS", "HTTP", "HTTP", "HTTPS", "HTTPS", "HTTPS", "HTTPS", "HTTPS"]
  tags                     = module.tags.common_tags
  application_root_domain  = module.vpc.root_domain_name
  services                 = ["base", "correspondence", "intake", "workflow", "monetary", "web", "docuedge", "jbpm", "communication", "eventlogging", "issue", "businessrule", "payment"]
  subnets                  = module.vpc.app_subnet_ids
  vpc_id                   = module.vpc.vpc_id
  web_subnet               = module.vpc.web_subnet_ids
  db_subnets               = module.vpc.database_subnet_ids
  deployment_sso_role_name = module.vpc.deployment_sso_role_name
  expose_web               = false
  workstation_subnets      = module.vpc.workstation_subnets
  kms_s3_arn               = module.kms.s3_arn
  kms_cloudwatch_arn       = module.kms.cloudwatch_arn
  kms_cloudwatch_id        = module.kms.cloudwatch_key_id
  kms_ecr_arn              = module.kms.ecr_arn
  secretsmanager_kms_arn           = module.kms.secretsmanager_arn
}

module "rds_upgrade_databases" {
  source = "../modules/rds-upgrade.1.0.0"

  instance_name                    = "${var.agency}-${var.project}-${var.environment}-mysql-upgrade-cluster"
  workstation_subnets              = ["10.159.162.0/24", "10.159.161.0/24"]
  database_subnet_ids              = module.vpc.database_subnet_ids
  app_subnet_ids                   = module.vpc.app_subnet_ids
  vpc_id                           = module.vpc.vpc_id
  storage_size                     = 100
  tags                             = module.tags.common_tags
  hosted_zone_id                   = module.vpc.hosted_zone_id
  control_tower_sso_infra_iam_role = module.vpc.control_tower_sso_infra_iam_role
  application_root_domain          = module.vpc.root_domain_name
  secretsmanager_kms_arn           = module.kms.secretsmanager_arn

}

module "sftp_gateway" {
  source                  = "../modules/sftp_gateway.1.0.0"
  application_root_domain = module.vpc.root_domain_name
  kms_s3_arn              = module.kms.s3_arn

  tags = module.tags.common_tags
}

module "elastic_cache_redis" {
  source = "../modules/elastic_cache.1.0.0"

  app_subnet_ids      = module.vpc.app_subnet_ids
  cluster_id          = "${var.agency}-${var.project}-${var.environment}-redis-cluster"
  vpc_id              = module.vpc.vpc_id
  ingress_ports       = ["6379"]
  egress_ports        = ["6379"]
  egress_cidr_ranges  = ["0.0.0.0/0"]
  workstation_subnets = module.vpc.workstation_subnets
  tags                = module.tags.common_tags
}

module "msk" {
  source              = "../modules/msk.1.0.0"
  cluster_name        = "${var.agency}-${var.project}-${var.environment}-msk-cluster"
  subnets             = module.vpc.app_subnet_ids
  vpc_id              = module.vpc.vpc_id
  ingress_ports       = ["9906", "9908", "9096", "9092", "2182", "9098", "9196"]
  egress_ports        = ["9906", "9908", "9096", "9092", "2182", "9098", "9196"]
  kafka_version       = "3.3.1"
  instance_type       = "kafka.m5.large"
  tags                = module.tags.common_tags
  kms_msk_arn         = module.kms.msk_key_arn
  workstation_subnets = ["10.159.162.0/24", "10.159.161.0/24"]
  replica_multiplier  = 1
}

module "data_reporting_and_analytics" {
  source = "../modules/data_reporting.1.0.0"

  rds_instance_name                          = "${var.agency}-${var.project}-${var.environment}-mysql-tableau"
  workstation_subnets                        = ["10.159.162.0/24", "10.159.161.0/24"]
  database_subnet_ids                        = module.vpc.database_subnet_ids
  vpc_id                                     = module.vpc.vpc_id
  kms_ebs_arn                                = module.kms.ebs_arn
  storage_size                               = 100
  tags                                       = module.tags.common_tags
  source_db_secret_arn                       = module.rds_upgrade_databases.rds_credentials_secret_arn
  source_db_hostname                         = module.rds_upgrade_databases.rds_host_name
  dms_replication_instance_availability_zone = "us-east-1a"
  replication_instance_class                 = "dms.r4.xlarge"
  restore_from_snapshot                      = true
  db_snapshot_identifier_id                  = "latest-for-tablea-dms-issue-upg-dev2"
  secretsmanager_kms_arn                     = module.kms.secretsmanager_arn
}

module "batch_application" {
  source = "../modules/batch_app.1.0.0"

  ami_id                      = "ami-07f69be0aa71c5868"
  subnet_ids                  = element(module.vpc.app_subnet_ids, 0)
  instance_name               = "${var.agency}-${var.project}-${var.environment}-batch-application"
  instance_type               = "c4.xlarge"
  vpc_id                      = module.vpc.vpc_id
  ingress_ports = ["443", "22", "3389", "80", "3306", "9092", "2181"]
  egress_ports                = ["443", "22", "3389", "80", "3306", "9092", "2181"]
  ingress_cidr_ranges         = module.vpc.app_subnet_cidir_list
  tags                        = module.tags.common_tags
  workstation_subnets         = module.vpc.workstation_subnets
  application_root_domain     = module.vpc.root_domain_name
  app_subnets                 = module.vpc.app_subnet_ids
  hosted_zone_id              = module.vpc.hosted_zone_id
  batch_listener_hostname     = "EC2AMAZ-RRAVA3D"
  iam_instance_profile_policy = module.vpc.oit_support_policy
  deployment_sso_role_name    = module.vpc.deployment_sso_role_name
  kms_s3_arn                  = module.kms.s3_arn
  secretsmanager_kms_arn      = module.kms.secretsmanager_arn
  kms_cloudwatch_arn          = module.kms.cloudwatch_arn
  kms_ecr_arn                 = module.kms.ecr_arn
}

# module "sns" {
#   source = "../modules/sns.1.0.0"
#   tags   = module.tags.common_tags
#   kms_sns_arn = module.kms.sns_arn
# }

module "jemeter_performance_testing" {
  source = "../modules/jmeter.1.0.0"

  master_node_ami_id          = "ami-07f69be0aa71c5868"
  agent_node_admi_id          = "ami-07f69be0aa71c5868"
  number_of_agents            = 2
  subnet_ids                  = "subnet-0692c83098af1580b"
  instance_name               = "${var.agency}-${var.project}-${var.environment}-jmeter-perf"
  instance_type               = "c4.xlarge"
  vpc_id                      = module.vpc.vpc_id
  ingress_ports               = ["88","135","389","445","636","3268","9389","123","53","464","3268","3269","3389"]
  ingress_cidr_ranges         = module.vpc.app_subnet_cidir_list
  tags                        = module.tags.common_tags
  workstation_subnets         = module.vpc.workstation_subnets
  application_root_domain     = module.vpc.root_domain_name
  app_subnets                 = ["subnet-0692c83098af1580b", "subnet-0c98ad71f462bdc2c"]
  iam_instance_profile_policy = "oit_infra_d_ssm_and_cloudwatch_policy"
  deployment_sso_role_name    = "AWSReservedSSO_cdle-famli-infradmin-d_3d39ed56d2b9151a"
  secretsmanager_kms_arn      = module.kms.secretsmanager_arn
}
