provider "aws" {
  region = "ap-southeast-1"    

}
# S3 bucket
resource "aws_s3_bucket" "nextjs_bucket" {
  bucket = "nextjs-portfolio-bucket-fj89"

}



# S3 bucket ownership control(to define the ownership of the object inside the bucket)
resource "aws_s3_bucket_ownership_controls" "nextjs_bucket_ownership_controls"{
    bucket = aws_s3_bucket.nextjs_bucket.id
    rule {
      object_ownership = "BucketOwnerPrefferred"  
    }    
}
# Public access for the s3 bucket(it provides centralized way to manage public access settings )
resource "aws_s3_bucket_public_access_block" "nextjs_bucket_public_access_block" {
  bucket = aws_s3_bucket.nextjs_bucket.id

  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false

  
}

# bucket (granular permissions for the s3 bucket)
resource "aws_s3_bucket_acl" "nextjs_bucket_acl"{

   depends_on = [
    aws_s3_bucket_ownership_controls.nextjs_bucket_ownership_controls,
    aws_s3_bucket_public_access_block.nextjs_bucket_public_access_block

     ] 

   bucket = aws_s3_bucket.nextjs_bucket.id
   acl = "public-read"  

  
}
# bucket policy(define detailed access bucket and its objects using IAM policy syntax)
resource "aws_s3_bucket_policy" "nextjs_bucket_policy" {
    bucket = aws_s3_bucket.nextjs_bucket.id

    policy = jsondecode(({
      version = "2012-10-17"
      Statement = [
        {
           Sid = "PublicReadGetObject"
           Effect = "Allow"
           Principal = "*"
           Action = "s3:GetObject"
           Resource = "${aws_s3_bucket.nextjs_bucket.arn}/*"

        }
      ]  
    }))
  
}