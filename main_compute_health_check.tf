# resource "google_compute_health_check" "autohealing" {
#   provider = google-beta

#   project = local.project_id
#   name    = "autohealing-health-check"

#   timeout_sec         = 5
#   check_interval_sec  = 5
#   healthy_threshold   = 2
#   unhealthy_threshold = 10

#   tcp_health_check {
#     port = "667"
#   }

#   log_config {
#     enable = true
#   }
# }
