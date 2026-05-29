output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.app.id
}

output "public_ip" {
  description = "Public IP — open http://<this-ip>/ in your browser"
  value       = aws_instance.app.public_ip
}

output "website_url" {
  description = "Application URL (after docker compose finishes on the instance)"
  value       = "http://${aws_instance.app.public_ip}/"
}

output "ssh_command" {
  description = "SSH as ec2-user (replace path to your .pem)"
  value       = "ssh -i <your-key.pem> ec2-user@${aws_instance.app.public_ip}"
}

output "deploy_hint" {
  description = "Manual deploy if github_repo_url was empty"
  value       = "scp -r project ec2-user@${aws_instance.app.public_ip}:/opt/ecommerce/app && ssh ec2-user@${aws_instance.app.public_ip} 'cd /opt/ecommerce/app && docker compose -f docker-compose.aws.yml up -d --build'"
}
