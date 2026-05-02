# METADATA
# title: Require Standard Tags
# description: All taggable AWS resources must have Project, Environment, and ManagedBy tags.
# scope: rule

package terraform.aws.tagging

import rego.v1

required_tags := {"Project", "Environment", "ManagedBy"}

taggable_resource_types := {
    "aws_s3_bucket",
    "aws_kms_key",
    "aws_dynamodb_table",
    "aws_vpc",
    "aws_subnet",
    "aws_security_group",
    "aws_iam_role",
    "aws_cloudtrail",
    "aws_guardduty_detector",
}

deny contains msg if {
    some resource_type in taggable_resource_types
    resource := input.resource[resource_type][name]
    existing_tags := {k | resource.values.tags[k]}
    missing := required_tags - existing_tags
    count(missing) > 0
    msg := sprintf(
        "Resource '%s.%s' is missing required tags: %v",
        [resource_type, name, missing]
    )
}
