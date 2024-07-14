resource "google_project_service" "default" {
  service                    = "compute.googleapis.com"
  disable_on_destroy         = false
  disable_dependent_services = false
}
