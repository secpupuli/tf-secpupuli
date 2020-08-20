data "github_team" "admins" {
  slug = var.team_slug
}

data "github_repositories" "repos" {
  query = "org:secpupuli"
}

resource "github_repository" "repo" {
  name      = var.repo_name
  auto_init = true

  # Only if the repository already exists can we set the default branch
  default_branch = contains(data.github_repositories.repos.names, var.repo_name) ? "main" : null
}

resource "github_team_repository" "team_push_permission" {
  team_id    = data.github_team.admins.id
  repository = github_repository.repo.name
  permission = "push"
}

resource "github_branch" "main" {
  repository = var.repo_name
  branch     = "main"
  depends_on = [
    github_repository.repo
  ]
}

resource "github_branch_protection" "branch_protection" {
  repository     = github_repository.repo.name
  branch         = "main"
  enforce_admins = true
  restrictions {
    teams = [var.team_slug]
  }
  depends_on = [
    github_branch.main,
  ]
}
