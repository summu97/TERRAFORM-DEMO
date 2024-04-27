variable "machine_type" {
type = string
default = "n2-standard-2"
}

variable "name" {
type = string
default = "bastion-server"
}

variable "name_private" {
type = string
default = "private-server"
}

variable "zone" {
type = string
default = "us-central1-a"
}

variable "image" {
type = string
default = "debian-cloud/debian-11"
}

variable "machine_type_private" {
type = string
default = "n2-standard-2"
}

variable "zone_private" {
type = string
default = "us-central1-a"
}

variable "image_private" {
type = string
default = "debian-cloud/debian-11"
}
