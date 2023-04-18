resource "aws_elastic_beanstalk_configuration_template" "tf_template" {
  name                = "tf-test-template-config"
  application         = aws_elastic_beanstalk_application.form_io.name
  solution_stack_name = "64bit Amazon Linux 2 v3.5.2 running Docker"

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(", ", var.app_subnet_ids)
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.formio_instance_profile.name
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.formio_eb_role.name
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = aws_security_group.eb_formio_sg.id
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "StreamLogs"
    value     = "true"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "false"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = "internal"
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs:health"
    name      = "HealthStreamingEnabled"
    value     = "true"
  }

  setting {
    namespace = "aws:elb:loadbalancer"
    name      = "CrossZone"
    value     = "true"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "license_key"
    value     = "aCContkeXBSugebW6vvKWMi4O6Y4Q"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "MONGO"
    value     = "mongodb://formio:${random_password.form_io_docdb_password.result}@${aws_docdb_cluster.docdb.endpoint}:27017/formio?ssl=true&retryWrites=false"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "ADMIN_EMAIL"
    value     = "parikatla@deloitte.com"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "ADMIN_PASS"
    value     = "deloitte"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "LICENSE_KEY"
    value     = "aCContkeXBSugebW6vvKWMi4O6Y4Q"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PORTAL_ENABLED"
    value     = var.portal_enabled
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "MONGO_CA"
    value     = "/src/certs/rds-combined-ca-bundle.pem"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DEBUG"
    value     = "*.*"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_SECRET"
    value     = "devenv"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PORTAL_SECRET"
    value     = "devenv"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "JWT_SECRET"
    value     = "devenv"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "FORMIO_S3_KEY"
    value     = jsondecode(aws_secretsmanager_secret_version.formio_iam_keypair_secret_version.secret_string)["username"]
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "FORMIO_S3_SECRET"
    value     = jsondecode(aws_secretsmanager_secret_version.formio_iam_keypair_secret_version.secret_string)["password"]
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "FORMIO_S3_BUCKET"
    value     = aws_s3_bucket.formio-pdf-bucket.id
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "FORMIO_S3_REGION"
    value     = "us-east-1"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t3a.xlarge"
  }

  setting {
    namespace = "aws:elbv2:listener:default"
    name      = "SSLCertificateArns"
    value     = aws_acm_certificate.formio_service_certificate.arn
  }

  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "ListenerEnabled"
    value     = "true"
  }

  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "Protocol"
    value     = "HTTPS"
  }

  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "SSLCertificateArns"
    value     = aws_acm_certificate.formio_service_certificate.arn
  }
}
