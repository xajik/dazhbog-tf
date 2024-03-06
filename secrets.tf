data "aws_secretsmanager_secret" "secrets_manager_prod_zeus_main" {
  arn = "arn:aws:secretsmanager:us-east-1:00000000000:secret:secret/prd"
}

data "aws_secretsmanager_secret_version" "secrets_value_prod_zeus_main" {
  secret_id = data.aws_secretsmanager_secret.secrets_manager_prod_zeus_main.id
}

locals {
  secrets_map                  = jsondecode(data.aws_secretsmanager_secret_version.secrets_value_prod_zeus_main.secret_string)
  secret_RDS_DB_NAME           = local.secrets_map["RDS_DB_NAME"]
  secret_RDS_USERNAME          = local.secrets_map["RDS_USERNAME"]
  secret_RDS_PASSWORD          = local.secrets_map["RDS_PASSWORD"]
  secret_RDS_DB_IDENTIFIER     = local.secrets_map["RDS_DB_IDENTIFIER"]
  secret_JWT_ACCESS_SECRET     = local.secrets_map["JWT_ACCESS_SECRET"]
  secret_JWT_REFRESH_SECRET    = local.secrets_map["JWT_REFRESH_SECRET"]
  secret_OPEN_AI_API_KEY       = local.secrets_map["OPEN_AI_API_KEY"]
  secret_GOOGLE_VISION_API_KEY = local.secrets_map["GOOGLE_VISION_API_KEY"]
  secret_CLOUDFLARE_AI_API_KEY = local.secrets_map["CLOUDFLARE_AI_API_KEY"]
  secret_CLOUDFLARE_ACCOUNT    = local.secrets_map["CLOUDFLARE_ACCOUNT"]
  secret_GOOGLE_PALM2_API_KEY  = local.secrets_map["GOOGLE_PALM2_API_KEY"]
}