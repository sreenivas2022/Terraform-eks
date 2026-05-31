terraform {
  backend "s3" {
    bucket = "leela-terraform-s3"
    key    = "terraform/terraform.tfstate"
    region = "ap-south-1"

    #incase s3 bucket is in another account to provide the assume_role
    #assume_role {
    #role_arn = arn:aws:iam::123456789012:role/marketingadminrole
  #}
    #dynamodb_table = ""
  }

}
