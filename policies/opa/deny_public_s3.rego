# METADATA
# title: Deny S3 Public Access
# description: S3 buckets must have all public access block settings enabled.
# scope: rule

package terraform.aws.s3.public_access

import rego.v1

deny contains msg if {
    resource := input.resource.aws_s3_bucket_public_access_block[name]
    not resource.values.block_public_acls == true
    msg := sprintf("S3 bucket '%s' must set block_public_acls = true", [name])
}

deny contains msg if {
    resource := input.resource.aws_s3_bucket_public_access_block[name]
    not resource.values.block_public_policy == true
    msg := sprintf("S3 bucket '%s' must set block_public_policy = true", [name])
}

deny contains msg if {
    resource := input.resource.aws_s3_bucket_public_access_block[name]
    not resource.values.ignore_public_acls == true
    msg := sprintf("S3 bucket '%s' must set ignore_public_acls = true", [name])
}

deny contains msg if {
    resource := input.resource.aws_s3_bucket_public_access_block[name]
    not resource.values.restrict_public_buckets == true
    msg := sprintf("S3 bucket '%s' must set restrict_public_buckets = true", [name])
}
