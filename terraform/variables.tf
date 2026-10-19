variable "region" {
  description = "AWS region for the S3 bucket and provider"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name, used as a prefix for resource names and the Project tag"
  type        = string
  default     = "agulaldi-portfolio1"
}

variable "environment" {
  description = "Deployment environment, used for the Environment tag"
  type        = string
  default     = "production"
}

variable "domain_name" {
  description = "Optional custom domain for the site (requires an ACM certificate in us-east-1; not wired yet)"
  type        = string
  default     = ""
}

variable "github_repository" {
  description = "GitHub repository (owner/name) allowed to assume the deploy role via OIDC"
  type        = string
  default     = "agulaldi/Ultimate-Agentic-DevOps-with-Claude-Code"
}
