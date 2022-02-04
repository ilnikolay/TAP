output "repo_url" {
  value = aws_ecr_repository.this.repository_url
}

output "rds_endpoint" {
  value = aws_db_instance.rds.address
}

output "alb_ip_dns" {
  value = aws_lb.this.dns_name
}