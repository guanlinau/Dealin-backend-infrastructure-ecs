terraform {
  cloud {
    organization = "Dealin"

    workspaces {
      name = "terraform_backend_uat"
    }
  }
}