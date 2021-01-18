resource "aws_s3_bucket" "irsa" {
  bucket = "irsa-test-bucket"
  acl    = "private"

  tags = {
    Name = "irsa test bucket"
    env  = "test"
  }
}
