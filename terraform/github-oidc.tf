# -----------------------------------------------------------------------------
# GitHub Actions OIDC: keyless deploys from the main branch of this repo only
# -----------------------------------------------------------------------------
locals {
  github_owner_name          = split("/", var.github_repository)[0]
  github_repository_name     = split("/", var.github_repository)[1]
  github_oidc_subject_prefix = "repo:${local.github_owner_name}@${var.github_owner_id}/${local.github_repository_name}@${var.github_repository_id}"
}

resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]

  # AWS validates GitHub's OIDC tokens against its own trusted CA library, so
  # these thumbprints aren't used for verification, but the API still accepts them.
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd",
  ]

  tags = local.common_tags
}

data "aws_iam_policy_document" "github_actions_assume" {
  statement {
    sid     = "AllowGitHubOIDCMainBranch"
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    # Exact match: only pushes to main can assume the role (no PRs, tags or forks).
    # This repo uses GitHub's immutable subject format, which embeds the owner and
    # repository IDs ("repo:owner@<id>/name@<id>:..."), so a deleted and re-created
    # repo with the same name cannot assume the role.
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["${local.github_oidc_subject_prefix}:ref:refs/heads/main"]
    }
  }
}

resource "aws_iam_role" "github_actions_deploy" {
  name                 = "${var.project_name}-github-actions-deploy"
  description          = "Assumed by GitHub Actions (${var.github_repository}, main) to deploy the site"
  assume_role_policy   = data.aws_iam_policy_document.github_actions_assume.json
  max_session_duration = 3600
  tags                 = local.common_tags
}

data "aws_iam_policy_document" "github_actions_deploy" {
  statement {
    sid       = "ListSiteBucket"
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.site.arn]
  }

  statement {
    sid    = "ManageSiteObjects"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]
    resources = ["${aws_s3_bucket.site.arn}/*"]
  }

  statement {
    sid       = "InvalidateSiteDistribution"
    effect    = "Allow"
    actions   = ["cloudfront:CreateInvalidation"]
    resources = [aws_cloudfront_distribution.site.arn]
  }
}

resource "aws_iam_role_policy" "github_actions_deploy" {
  name   = "${var.project_name}-site-deploy"
  role   = aws_iam_role.github_actions_deploy.id
  policy = data.aws_iam_policy_document.github_actions_deploy.json
}
