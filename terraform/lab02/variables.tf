variable "region" {
  default = "eu-central-1"
}

variable "vpc_cidr" {
  type        = string
  description = "The IP range to use for the VPC"
  default     = "10.0.0.0/16"
}

variable "ssh_key_name" {
  description = "Name of the ssh key"
  type        = string
  default     = "TAP_NIK"
}