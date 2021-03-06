provider "aws" {
  version = "~> 2.2"
  region  = "us-west-2"
}

resource "random_string" "cloudfront_rstring" {
  length  = 18
  upper   = false
  special = false
}

module "cloudfront_custom_origin" {
  source              = "../../module"
  domain_name         = "customdomain.testing.example.com"
  origin_id           = "${random_string.cloudfront_rstring.result}"
  enabled             = true
  comment             = "This is a test comment"
  default_root_object = "index.html"
  bucket_logging      = false

  # Custom Origin
  https_port             = 443
  origin_protocol_policy = "https-only"

  # default cache behavior
  allowed_methods  = ["GET", "HEAD"]
  cached_methods   = ["GET", "HEAD"]
  path_pattern     = "*"
  target_origin_id = "${random_string.cloudfront_rstring.result}"

  # Forwarded Values
  query_string = false

  #Cookies
  forward = "none"

  viewer_protocol_policy = "redirect-to-https"
  default_ttl            = "3600"

  price_class = "PriceClass_200"

  # restrictions
  restriction_type = "whitelist"
  locations        = ["US", "CA", "GB", "DE"]

  # Certificate
  cloudfront_default_certificate = true
}
