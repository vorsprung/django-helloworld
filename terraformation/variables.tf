#variable "databasepassword" {
#  type    = string
#}

variable "log_location_prefix" {
  default = "my-lb-logs"
}

variable "region" {
  default = "eu-west-1"
}

variable "log_bucket_name" {
  default = "test-log-bucket"
}

