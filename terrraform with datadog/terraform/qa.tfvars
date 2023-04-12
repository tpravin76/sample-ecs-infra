aws_region        = "us-east-1"

# these are zones and subnets examples
availability_zones = ["us-east-1a", "us-east-1b"]
public_subnets     = ["172.31.100.0/24", "172.31.101.0/24"]
private_subnets    = ["172.31.150.0/24", "172.31.151.0/24"]

# these are used for tags
app_name        = "sample-app"
app_environment = "development"

vpc_id = "vpc-b8148edd"
eip_id = "eipalloc-07297c4b933c2e728"

# secret manager constants
SF_USER = "arn:aws:secretsmanager:us-east-1:817832525236:secret:sch-ingestor/qa/sf.user-fkL3VD"
SF_PASS = "arn:aws:secretsmanager:us-east-1:817832525236:secret:sch-ingestor/qa/sf.pass-KJI5w7"
SF_SANDBOX = "arn:aws:secretsmanager:us-east-1:817832525236:secret:sch-ingestor/qa/sf.sandbox-aiKzvk"
SF_CLIENT_ID = "arn:aws:secretsmanager:us-east-1:817832525236:secret:sch-ingestor/qa/sf.client_id-KJDqKT"
SF_CLIENT_SECRET = "arn:aws:secretsmanager:us-east-1:817832525236:secret:sch-ingestor/qa/sf.client_secret-2dPCN4"
ES_PASS = "arn:aws:secretsmanager:us-east-1:817832525236:secret:sch-ingestor/qa/es.pass-RtxwYF"
REPLICATE_PASS = "arn:aws:secretsmanager:us-east-1:817832525236:secret:sch-ingestor/qa/replicate.pass-LTkLty"
DATADOG_API_KEY = "arn:aws:secretsmanager:us-east-1:817832525236:secret:DdApiKeySecret-EdVlYQsg5okf-VbD1Ic"