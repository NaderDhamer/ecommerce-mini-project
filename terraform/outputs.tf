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
  description = "Deploy with Ansible (git) after apply"
  value       = "./scripts/ansible-deploy.sh -i <your-key.pem> -r https://github.com/YOUR_USER/Ecommerce-mini-project.git -h ${aws_instance.app.public_ip}"
}
