# AWS Academy Learner Lab: use the session credentials from the lab console
# (Access Key, Secret Key, Session Token). Do not use assume_role — it is blocked.
provider "aws" {
  region = var.aws_region
}
