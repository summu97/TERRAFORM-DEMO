terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4"
    }
  }
}

provider "google" {
  project     = "ringed-hallway-417305"
  region      = "us-east1-b"
}

terraform {
  backend "gcs" {
    bucket  = "adq-bucket-getteam"
    prefix  = "terraform/state"
  }
}

module "bastion-host" {
source = "./bastion-host"
}
