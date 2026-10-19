# -----------------------------------------------------------------------------
# Remote state backend (S3 + DynamoDB locking)
#
# Bootstrap steps:
#   1. First run `terraform init` with this block commented out (local state).
#   2. Create the state bucket and DynamoDB lock table (e.g. `terraform apply`
#      or a separate bootstrap config). The lock table needs a `LockID` (String)
#      partition key.
#   3. Uncomment the block below and fill in the bucket/table names.
#   4. Run `terraform init -migrate-state` to move local state into S3.
# -----------------------------------------------------------------------------

# terraform {
#   backend "s3" {
#     bucket         = "agulaldi-portfolio1-tfstate"
#     key            = "agulaldi-portfolio1/production/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "agulaldi-portfolio1-tf-lock"
#     encrypt        = true
#   }
# }
