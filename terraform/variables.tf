variable "aws_region" {
  description = "AWS region (must match your Learner Lab session region)."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Prefix for resource names."
  type        = string
  default     = "ecommerce"
}

variable "instance_type" {
  description = "EC2 instance type. t3.small or larger recommended for Docker + MySQL."
  type        = string
  default     = "t3.small"
}

variable "key_name" {
  description = "Name of an existing EC2 key pair in this region (create in EC2 console before apply)."
  type        = string
}

variable "ssh_cidr" {
  description = "CIDR allowed to SSH to the instance (use your public IP/32 in Learner Lab)."
  type        = string
  default     = "0.0.0.0/0"
}

variable "github_repo_url" {
  description = "Optional public Git URL to clone on first boot. Leave empty to deploy manually over SSH."
  type        = string
  default     = ""
}

variable "db_password" {
  description = "MySQL root password written to /opt/ecommerce/.env on the instance."
  type        = string
  sensitive   = true
  default     = "ChangeMeInLearnerLab123!"
}

variable "root_volume_gb" {
  description = "Root EBS volume size in GB (Docker images need space)."
  type        = number
  default     = 30
}
