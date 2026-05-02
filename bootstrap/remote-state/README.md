# Remote State Bootstrap

Creates the resources needed for secure Terraform remote state:

- S3 bucket with versioning.
- Customer-managed KMS key with rotation.
- Server-side encryption using KMS.
- Public access block and bucket-owner-enforced ownership.
- Bucket policy denying insecure transport.
- DynamoDB lock table with point-in-time recovery and encryption.

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
```

Review the plan before applying. This root intentionally has no backend block because it creates the backend resources.
