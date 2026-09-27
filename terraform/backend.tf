terraform {
  backend "gcs" {
    bucket = "foodtrack-a-tfstate-form-gke-eleve01-4621"
    prefix = "terraform/state"
  }
}