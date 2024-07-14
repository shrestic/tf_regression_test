resource "google_compute_autoscaler" "default" {
  for_each = local.compute_instance_templates
  provider = google-beta
  project  = local.project_id
  name     = lower("${local.cluster_name}-${local.cluster_type}-mig-${split("~", each.key)[1]}")
  zone     = local.zone
  target   = google_compute_instance_group_manager.default["${each.key}"].id

  autoscaling_policy {
    max_replicas    = 1000
    min_replicas    = each.value
    cooldown_period = 300

    # scaling_schedules {
    #   name                  = "my-autoscaler-startup-${each.key}"
    #   description           = "Startup cluster"
    #   min_required_replicas = each.value
    #   schedule              = var.autoscalar_startup_cron
    #   time_zone             = "America/Chicago"
    #   duration_sec          = 3600
    # }

    # scaling_schedules {
    #   name                  = "my-autoscaler-shutdown-${each.key}"
    #   description           = "Shutdown cluster"
    #   min_required_replicas = 0
    #   schedule              = var.autoscalar_shutdown_cron
    #   time_zone             = "America/Chicago"
    #   duration_sec          = 3600
    # }
  }
}


