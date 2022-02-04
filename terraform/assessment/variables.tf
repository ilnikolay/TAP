variable "region" {
  default = "eu-central-1"
}

variable "repo_name" {
  default = "nik-tap-a"
}

variable "common_tag" {
  default = "tap-nik"
}

variable "public_subnet" {
   type = map
   default = {
      sub-1 = {
         az = "eu-central-1a"
         cidr = "10.0.1.0/24"
      }
      sub-2 = {
         az = "eu-central-1b"
         cidr = "10.0.2.0/24"
      }
      sub-3 = {
         az = "eu-central-1c"
         cidr = "10.0.3.0/24"
      }
   }
}

variable "private_subnet" {
   type = map
   default = {
      sub-1 = {
         az = "eu-central-1a"
         cidr = "10.0.11.0/24"
      }
      sub-2 = {
         az = "eu-central-1b"
         cidr = "10.0.12.0/24"
      }
      sub-3 = {
         az = "eu-central-1c"
         cidr = "10.0.13.0/24"
      }
   }
}

variable "database_subnet" {
   type = map
   default = {
      sub-1 = {
         az = "eu-central-1a"
         cidr = "10.0.101.0/24"
      }
      sub-2 = {
         az = "eu-central-1b"
         cidr = "10.0.102.0/24"
      }
      sub-3 = {
         az = "eu-central-1c"
         cidr = "10.0.103.0/24"
      }
   }
}

variable "rds_cred" {
  default = {
    DB_USER = "postgres"
    DB_PASSWORD = "qwerty123"
  }

  type = map(string)
}