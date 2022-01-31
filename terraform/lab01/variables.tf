variable "my_ip" {
  description = "Personal IP to allow SSH connection"
  type        = string
  default     = "MY_IP/32"
}

variable "ami" {
  description = "Ami of the EC2 instance"
  type        = string
  default     = "ami-0d527b8c289b4af7f"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ssh_key_name" {
  description = "Name of the ssh key"
  type        = string
  default     = "TAP_NIK"
}

variable "db_password" {
  description = "RDS root user password"
  type        = string
  sensitive   = true
}