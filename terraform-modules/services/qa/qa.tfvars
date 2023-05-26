aws_region        = "us-west-2"

# these are zones and subnets
availability_zones = ["us-west-2a", "us-west-2b"]
public_subnets     = ["10.10.100.0/24", "10.10.101.0/24"]
private_subnets    = ["10.10.0.0/24", "10.10.1.0/24"]

# these are used for tags
app_name        = "schedule-api"
app_environment = "qa"

emails = ["pravin.taralkar@languageline.com"]

# secret manager constants
DYNAMODB_ACCESSKEY = ""
DYNAMODB_ACCESSSECRET = ""
SF_USER = ""
SF_PASS = ""
SF_CLIENT_ID = ""
SF_CLIENT_SECRET = ""
JWT_SECRET = ""
ES_PRIMARY_USER = ""
ES_PRIMARY_PASS = ""
DATADOG_API_KEY = ""
