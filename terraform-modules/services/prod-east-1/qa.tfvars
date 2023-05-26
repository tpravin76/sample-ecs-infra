aws_region        = "us-east-1"

# these are zones and subnets
availability_zones = ["us-east-1a", "us-east-1b"]
public_subnets     = ["10.10.104.0/24", "10.10.105.0/24"]
private_subnets    = ["10.10.4.0/24", "10.10.5.0/24"]

# these are used for tags
app_name        = "schedule-api"
app_environment = "qa"

vpc_id = "vpc-039c5b44dbf261480"
emails = ["pravin.taralkar@languageline.com"]

# secret manager constants
DYNAMODB_ACCESSKEY = ""
DYNAMODB_ACCESSSECRET = ""
SF_USER = ""

