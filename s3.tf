resource "aws_s3_bucket" "bucket" {
  bucket = "terraform-s3-ip-access-example"
  force_destroy = true

  tags = {
    "Name" = "terraform-s3-ip-access-example"
  }
}

resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "bucket" {
  bucket =  aws_s3_bucket.bucket.id

  policy = jsonencode(
    {
      "Version": "2008-10-17",
      "Id": "PolicyForBucketIpAccess",
      "Statement": [
        {
          "Sid": "IPAllow",
          "Effect": "Deny",
          "Principal": "*",
          "Action": "s3:*",
          "Resource": [
            "${aws_s3_bucket.bucket.arn}",
            "${aws_s3_bucket.bucket.arn}/*"
          ],
          "Condition": {
            "NotIpAddress": {
              "aws:SourceIp": var.allow_ip_address_block
            }
          }
        }
      ]
    }
  )
}