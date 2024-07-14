terraform {
  backend "s3" {
    bucket= "fj-my-terraform-state"
    key = "global/s3/terraform.tfstate"
    region = "ap-southeast-1"
    dynamodb_table = "terraform-lock-file"
    
  }    

}