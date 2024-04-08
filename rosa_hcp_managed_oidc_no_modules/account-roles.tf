data "rhcs_versions" "all" {}
data "rhcs_info" "current" {}

# In ROSA classic, we have to create both the policies and the roles. In HCP, we have the policies available in AWS natively, so we don't need to generate them. We do however need to generate the roles, and attach the correct policies to each via a Trust Relationship. We'll do that here.

# There are two ways to get the correct ARNs of the policies: We can either ask the OCM API to provide them for us, or we can hard-code them here. To future proof this, we will get them from OCM. However, if you wished you could get the correct ARNs from the AWS console and associate them yourself

# Get the data from OCM:
data "rhcs_hcp_policies" "all_policies" {}

# From this, loop over each and pull out the ARN and link it to the correct role that we will create after:

locals {
  account_roles_properties = [
    {
      principal_type       = "AWS"
      principal_identifier = "arn:aws:iam::${data.rhcs_info.current.ocm_aws_account_id}:role/RH-Managed-OpenShift-Installer"
      policy_arn           = data.rhcs_hcp_policies.all_policies.account_role_policies["sts_hcp_installer_permission_policy"]
      role_name            = "Installer"
    },
    {
      principal_type       = "AWS"
      principal_identifier = "arn:aws:iam::${data.rhcs_info.current.ocm_aws_account_id}:role/RH-Technical-Support-Access"
      policy_arn           = data.rhcs_hcp_policies.all_policies.account_role_policies.sts_hcp_support_permission_policy
      role_name            = "Support"
    },
    {
      principal_type       = "Service"
      principal_identifier = "ec2.amazonaws.com"
      policy_arn           = data.rhcs_hcp_policies.all_policies.account_role_policies.sts_hcp_instance_worker_permission_policy
      role_name            = "Worker"
    },
  ]
  account_roles_count = length(local.account_roles_properties)
}

# For each, make a trust document
data "aws_iam_policy_document" "custom_trust_policy" {
  count = local.account_roles_count

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = local.account_roles_properties[count.index].principal_type
      identifiers = [local.account_roles_properties[count.index].principal_identifier]
    }
  }
}

# And now create the role linking them together
module "account_iam_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = ">=5.34.0"
  count  = local.account_roles_count

  create_role = true

  # We've hardcoded this name above so that we don't have to chop/replace strings here and make this unreadable
  role_name = "${local.cluster_name}-${local.account_roles_properties[count.index].role_name}-Role"

  role_path                     = local.path

  create_custom_role_trust_policy = true
  custom_role_trust_policy        = data.aws_iam_policy_document.custom_trust_policy[count.index].json

  custom_role_policy_arns = [
    "${local.account_roles_properties[count.index].policy_arn}"
  ]

  tags = merge(var.additional_tags, {
    rosa_hcp_policies      = true
    red-hat-managed        = true
    rosa_role_prefix       = var.cluster_name
    rosa_role_type         = "${local.account_roles_properties[count.index].role_name}"
    rosa_managed_policies  = true
  })
}

# Wait for the roles to be created
resource "time_sleep" "wait_10_seconds" {
  depends_on = [module.account_iam_role]

  create_duration = "10s"
}
