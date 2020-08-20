variable "github_token" {
  type = string
}

variable "pmc_members" {
  type = list(string)
}

variable "non_pmc_admins" {
  type = list(string)
}

variable "terraform_repos" {
  type = list(string)
}
