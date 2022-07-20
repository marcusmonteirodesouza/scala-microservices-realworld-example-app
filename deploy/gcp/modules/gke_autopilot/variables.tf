variable "name" {
  type        = string
  description = "The name of the GKE cluster"
}

variable "location" {
  type        = string
  description = "The location (region or zone) in which the cluster master will be created, as well as the default node location."
}

variable "network" {
  type        = string
  description = "The name or self_link of the Google Compute Engine network to which the cluster is connected."
}

variable "subnetwork" {
  type        = string
  description = "The name or self_link of the Google Compute Engine subnetwork in which the cluster's instances are launched."
}
