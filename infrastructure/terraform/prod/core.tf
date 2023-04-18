# module "tags" {
#   source              = "../modules/terraform-aws-tags-0.1"
#   agency_name         = var.agency
#   project_name        = var.project
#   environment_name    = var.environment
#   fundingrequest_name = var.fundingrequest
#   po_name             = var.po
# }

# module "vpc" {
#   source = "../modules/vpc.1.0.0"

#   vpc_id                   = "vpc-0121a3f9e32294aab"
#   hosted_zone_id           = "Z08092632UK0C4H5Y80P6"
#   root_domain_name         = "coawstest.com"
#   workstation_subnets      = ["10.159.162.0/24"]
#   database_subnet_ids      = ["subnet-01ea8b3b69a629046", "subnet-056fa7513f859ceac", "subnet-060e2c704af37c8c7"]
#   web_subnet_ids           = ["subnet-08dd9aff70691283c", "subnet-00d207329ea9886d0", "subnet-09f43c83099805188"]
#   app_subnet_ids           = ["subnet-03e384dd022ae535a", "subnet-0fcb7c400a43ed983", "subnet-034245282a048c491"]
#   deployment_sso_role_name = "AWSReservedSSO_cdle-famli-infradmin-t_0bab797fa6a9a334"
#   oit_support_role         = "oit-central-support-d-azdo-iac-tmp-base"
#   tags                     = module.tags.common_tags
# }

# module "ecs_core_application" {
#   source = "../modules/ecs.1.0.0"

#   cluster_name                       = "${var.agency}-${var.project}-${var.environment}-cluster"
#   ports                              = [443, 443, 443, 443, 443, 443, 8000, 8090, 443, 443]
#   health_check_protocol              = ["HTTPS", "HTTPS", "HTTPS", "HTTPS", "HTTPS", "HTTPS", "HTTP", "HTTP", "HTTPS", "HTTPS"]
#   tags                               = module.tags.common_tags
#   application_root_domain            = module.vpc.root_domain_name
#   application_route53_hosted_zone_id = module.vpc.hosted_zone_id
#   services                           = ["base", "correspondence", "intake", "workflow", "monetary", "web", "docuedge", "jbpm", "communication", "eventlogging"]
#   Internal                           = ["true", "true", "true", "true", "true", "false", "true", "true", "true", "true"]
#   subnets                            = module.vpc.app_subnet_ids
#   web_subnet                         = module.vpc.web_subnet_ids
#   vpc_id                             = module.vpc.vpc_id
#   db_subnets                         = module.vpc.database_subnet_ids
#   deployment_sso_role_name           = module.vpc.deployment_sso_role_name
#   expose_web                         = true
#   uat_tester_ips                     = ["182.68.82.235/32", "27.4.76.244/32", "49.205.230.191/32", "75.176.168.177/32", "45.21.63.144/32", "165.127.190.81/32", "73.243.52.31/32", "24.8.50.93/32", "98.41.97.14/32", "208.127.186.165/32", "156.108.172.100/32", "73.34.227.139/32", "67.176.15.217/32", "165.127.190.78/32", "156.108.172.100/32", "75.71.177.236/32", "156.108.172.100/32", "156.108.172.100/32", "156.108.172.100/32", "76.154.146.31/32", "70.59.8.199/32", "204.9.250.92/32", "73.243.31.61/32", "156.108.172.100/32", "73.153.88.228/32", "73.34.248.231/32", "173.53.124.126/32", "73.153.16.161/32", "73.95.74.189/32", "165.127.190.88/32", "18.211.112.60/32", "174.234.18.60/32", "10.159.162.0/24", "165.127.190.81/32", "45.25.180.161/32", "49.206.56.95/32", "27.6.123.123/32", "182.48.215.183/32", "165.127.190.69/32"]
# }

# module "rds_upgrade_databases" {
#   source = "../modules/rds-upgrade.1.0.0"

#   instance_name                   = "${var.agency}-${var.project}-${var.environment}-mysql-upgrade-cluster"
#   workstation_subnets             = ["10.159.162.0/24", "10.159.161.0/24"]
#   database_subnet_ids             = module.vpc.database_subnet_ids
#   app_subnet_ids                  = module.vpc.app_subnet_ids
#   vpc_id                          = module.vpc.vpc_id
#   storage_size                    = 100
#   tags                            = module.tags.common_tags
#   rds_snapshot_backup_sns_trigger = module.vpc.rds_microservices_db_backup_lambda_sns_topic_arn
# }


# module "elastic_cache_redis" {
#   source = "../modules/elastic_cache.1.0.0"

#   app_subnet_ids      = module.vpc.app_subnet_ids
#   cluster_id          = "${var.agency}-${var.project}-${var.environment}-redis-cluster"
#   vpc_id              = module.vpc.vpc_id
#   ingress_ports       = ["6379"]
#   egress_ports        = ["6379"]
#   egress_cidr_ranges  = ["0.0.0.0/0"]
#   ingress_cidr_ranges = ["0.0.0.0/0"]
#   tags                = module.tags.common_tags
# }

# module "msk" {
#   source              = "../modules/msk.1.0.0"
#   cluster_name        = "${var.agency}-${var.project}-${var.environment}-msk-cluster"
#   subnets             = module.vpc.app_subnet_ids
#   vpc_id              = module.vpc.vpc_id
# kms_msk_arn = module.kms.msk_key_arn
#   ingress_ports       = ["9906", "9908", "9096", "9092", "2182", "9098", "9196"]
#   egress_ports        = ["9906", "9908", "9096", "9092", "2182", "9098", "9196"]
#   egress_cidr_ranges  = module.vpc.app_subnet_ids
#   ingress_cidr_ranges = module.vpc.app_subnet_ids
#   kafka_version       = "3.3.1"
#   instance_type       = "kafka.m5.large"
#   tags                = module.tags.common_tags
#   workstation_subnets = ["10.159.162.0/24", "10.159.161.0/24"]
#   replica_multiplier  = 1
# }

# module "sns" {
#   source = "../modules/sns.1.0.0"
#   tags   = module.tags.common_tags
# kms_sns_arn = module.kms.sns_arn
# }

# module "batch_application" {
#   source = "../modules/batch_app.1.0.0"

#   ami_id               = "ami-0be29bafdaad782db"
# kms_docdb_arn = module.kms.docdb_arn
#   subnet_ids           = ["subnet-03e384dd022ae535a"]
#   instance_name        = "${var.agency}-${var.project}-${var.environment}-batch-application"
#   instance_type        = "c4.xlarge"
#   vpc_id               = module.vpc.vpc_id
#   ingress_ports        = ["443", "22", "3389", "80"]
#   egress_ports         = ["443", "22", "3389", "80"]
#   egress_cidr_ranges   = ["0.0.0.0/0"]
#   ingress_cidr_ranges  = ["0.0.0.0/0"]
#   tags                 = module.tags.common_tags
#   iam_instance_profile = "oit_infra_t_ssm_and_cloudwatch_role"
# }

# module "data_reporting_and_analytics" {
#   source = "../modules/data_reporting.1.0.0"

#   rds_instance_name                          = "${var.agency}-${var.project}-${var.environment}-mysql-tableau"
#   workstation_subnets                        = ["10.159.162.0/24", "10.159.161.0/24"]
#   database_subnet_ids                        = module.vpc.database_subnet_ids
#   vpc_id                                     = module.vpc.vpc_id
# kms_ebs_arn = module.kms.ebs_arn
#   storage_size                               = 100
#   tags                                       = module.tags.common_tags
#   source_db_secret_arn                       = module.rds_upgrade_databases.rds_credentials_secret_arn
#   source_db_hostname                         = module.rds_upgrade_databases.rds_host_name
#   dms_replication_instance_availability_zone = "us-east-1a"
#   replication_instance_class                 = "dms.t3.medium"
# }
