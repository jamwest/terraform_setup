variable "project_name" {
  type        = string
  description = "Name of the project"
}

variable "account_name" {
  type        = string
  description = "For naming s3 buckets uniquely"
}

variable "region" {
  type        = string
  description = "The aws region to deploy infrastructure to"
}