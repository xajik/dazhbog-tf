terraform {
  backend "http" {
  }
}

# Local state for testing: 
# terraform {
#   backend "local" {
#     path = "state/terraform.tfstate"
#   }
# }
