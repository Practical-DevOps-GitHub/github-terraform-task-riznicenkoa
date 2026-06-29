terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "github" {
  token = var.github_token
}

locals {
  repository = "github-terraform-task-riznicenkoa"
}

data "github_repository" "repo" {
  full_name = "riznicenkoa/github-terraform-task-riznicenkoa"
}

resource "github_repository_collaborator" "collab" {
  repository = github_repository.repo.name
  username   = "softserverdata"
  permission = "push"
}
resource "github_branch" "develop" {
  repository = github_repository.repo.name
  branch     = "develop"
}

resource "github_branch_default" "default" {
  repository = github_repository.repo.name
  branch     = "develop"
}
resource "github_branch_protection" "main" {
  repository_id = github_repository.repo.node_id
  pattern       = "main"

  required_pull_request_reviews {
    required_approving_review_count = 1
  }
terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "github" {
  token = var.github_token
}
resource "github_repository" "repo" {
  name       = "terraform-github-repo"
  visibility = "private"
  auto_init  = true
}
resource "github_repository_collaborator" "collab" {
  repository = github_repository.repo.name
  username   = "softserverdata"
  permission = "push"
}
resource "github_branch" "develop" {

  enforce_admins = true
}
resource "github_branch_protection" "develop" {
  repository_id = github_repository.repo.node_id
  pattern       = "develop"

  required_pull_request_reviews {
    required_approving_review_count = 2
  }

  enforce_admins = true
}
resource "github_repository_deploy_key" "key" {
  title      = "DEPLOY_KEY"
  repository = github_repository.repo.name
  key        = file("deploy_key.pub")
  read_only  = false
}
resource "github_actions_secret" "pat" {
  repository      = github_repository.repo.name
  secret_name     = "PAT"
  plaintext_value = var.github_token
}
