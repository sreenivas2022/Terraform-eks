variable "ecr_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "project" {
  type = string
}

variable "created_by" {
  type = string
}

variable "created_date" {
  type = string
}

variable "cross_account_ids" {
  type = list(string)
}