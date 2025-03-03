terraform {
  backend "s3" {
    bucket       = "remote-state-bucket-dev-003"
    key          = "terraform/s3-remote-state/files"
    encrypt      = true
    use_lockfile = true
    #dynamodb_table = "dynamodb-state-locking-table"
    region  = "ap-northeast-1"
    profile = "terraform-dev-role"
  }
}
