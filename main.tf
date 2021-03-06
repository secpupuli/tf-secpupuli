terraform {
  required_version = "~> 0.13.0"

  backend "remote" {
    organization = "VoxPupuli"

    workspaces {
      name = "github-secpupuli"
    }
  }
}

provider "github" {
  version      = "~> 2.9.2"
  organization = "secpupuli"
  token        = var.github_token
}

resource "github_membership" "owner" {
  for_each = toset(concat(var.pmc_members, var.non_pmc_admins))

  username = each.key
  role     = "admin"
}

resource "github_team" "terraform_admins" {
  name        = "Terraform Admins"
  description = "Team members can modify the terraform that controls Vox infrastructure"
}

resource "github_team_membership" "terraform_admin_member" {
  for_each = toset(concat(var.pmc_members, var.non_pmc_admins))

  team_id  = github_team.terraform_admins.id
  username = each.key
  role     = "maintainer" # If you try to set 'member', github will promote us back to maintainers as we're already repo owners
}

module "terraform_git_repo" {
  for_each  = toset(var.terraform_repos)
  source    = "./terraform_git_repo"
  repo_name = each.key
  team_slug = github_team.terraform_admins.slug
}
