terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "github" {
  owner = "Practical-DevOps-GitHub"
}

locals {
  repository = "github-terraform-task-riznicenkoa"
}

resource "github_repository_collaborator" "softservedata" {
  repository = local.repository
  username   = "softservedata"
  permission = "push"
}

resource "github_branch" "develop" {
  repository    = local.repository
  branch        = "develop"
  source_branch = "main"
}

resource "github_branch_default" "default" {
  repository = local.repository
  branch     = github_branch.develop.branch

  depends_on = [
    github_branch.develop
  ]
}

resource "github_branch_protection" "main" {
  repository_id = local.repository
  pattern       = "main"

  required_pull_request_reviews {
    required_approving_review_count = 1
    require_code_owner_reviews      = true
  }

  enforce_admins = true
}

resource "github_branch_protection" "develop" {
  repository_id = local.repository
  pattern       = "develop"

  required_pull_request_reviews {
    required_approving_review_count = 2
  }

  enforce_admins = true

  depends_on = [
    github_branch.develop
  ]
}

resource "github_repository_deploy_key" "deploy_key" {
  title      = "DEPLOY_KEY"
  repository = local.repository
  key        = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHhL7wq0ujoRyh3ZOACh4zdKnJtt7X2ZnUoCSB0dHWWi"
  read_only  = false
}

resource "github_actions_secret" "pat" {
  repository      = local.repository
  secret_name     = "PAT"
  plaintext_value = "PAT"
}
