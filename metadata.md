==========
INTRODUCTION:
==========
* Free and open source, Platform independent.
* Infrastructure as code.
* Terraform uses HCL(Hashicorp Configuration Language) language to create out our Infrastructure.
* Supports multiple-clouds(aws, azure, google).
* It follows life cycle.

==========
ADVANTAGES:
==========
* Reusablility of code.
* Manual effort reduced.
* Can automate creation of Infrastructure.
* also offers Dryrun.

==========
CONFIGURATION FILE:
==========
main.tf

==========
VARIABLE:
==========
* variable block
* variable.tf
* .tfvars

==========
LIFE CYCLE:
==========
* terraform init
* terraform plan
* terraform apply
* terraform destroy

==========
VERSION_CONSTANTS:
==========
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.68"
    }
  }
}

==========
USE: terraform init -upgrade
==========

==========
REMOTE_BACKEND:
==========
terraform {
  backend "gcs" {
    bucket  = "adq-bucket-getteam"
    prefix  = "terraform/state"
  }
}

==========
TERRAFORM WORKSPACE:
==========

* terraform workspace new dev
* terraform workspace list
* terraform workspace show
* terraform workspace select dev

==========
TERRAFORM GRAPH:
==========

* Command: terraform graph

==========
TAINT:
==========

* terraform taint RESOURCE_NAME
* terraform apply --auto-approve
* terraform untaint --auto-approve

==========
ALIAS & PROVIDER:
==========

* To link provider block with resource block.

==========
INSTALLATION:
==========
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

==========
Run terraform without json_key
==========
* gcloud auth application-default login















