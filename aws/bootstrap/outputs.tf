output "bucket_name" {
  description = "Bucket do remote state"
  value       = aws_s3_bucket.tfstate.bucket
}

output "backend_hcl" {
  description = "Conteúdo sugerido para environments/<env>/backend.hcl"
  value       = <<-EOT
    bucket       = "${aws_s3_bucket.tfstate.bucket}"
    key          = "aws/<env>/terraform.tfstate"
    region       = "${var.aws_region}"
    encrypt      = true
    use_lockfile = true
  EOT
}
