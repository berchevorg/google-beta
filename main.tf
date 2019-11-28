terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "berchevorg"

    workspaces {
      name = "google-beta"
    }
  }
}

variable "gcp_credentials" {}

variable "gcp_project_id" {
  #default = "sup-eng-eu"
}


provider "google-beta" {
  credentials = var.gcp_credentials
  project     = var.gcp_project_id
  #region      = "us-central1"
  #zone        = "us-central1-c"
}



resource "google_logging_metric" "logging_metric" {
  name   = "mass-foo-bar"
  filter = "resource.type=gae_app AND severity>=ERROR"
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    labels {
      key         = "priority"
      value_type  = "STRING"
      description = "queue priority label"
    }
    labels {
      key         = "outcome"
      value_type  = "STRING"
      description = "failure categories"
    }
  }

  label_extractors = {
    "priority" = "EXTRACT(jsonPayload.priority)"
    "outcome"  = "EXTRACT(jsonPayload.outcome)"
  }
}
