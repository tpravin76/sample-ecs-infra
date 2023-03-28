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


