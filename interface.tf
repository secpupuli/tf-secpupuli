variable "pmc_members" {
  type = list(string)
}

variable "non_pmc_admins" {
  type = list(string)
}

variable "terraform_repos" {
  type = list(string)
}

variable "github_token" {
  type        = string
  description = "The pccibot's 'Terraform' personal access token"
}
