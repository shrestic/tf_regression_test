data "google_compute_region_instance_template" "worker_node" {
  for_each = local.compute_instance_templates
  name     = split("~", each.key)[1]
  region   = local.region
}

resource "google_compute_instance_group_manager" "default" {
  for_each = local.compute_instance_templates
  provider = google-beta

  project = local.project_id
  name    = lower("${local.cluster_name}-${local.cluster_type}-mig-${split("~", each.key)[0]}")

  base_instance_name = lower("${local.cluster_name}-${local.cluster_type}-node-${split("~", each.key)[0]}")
  zone               = local.zone

  version {
    instance_template = "projects/${local.project_id}/regions/${local.region}/instanceTemplates/${split("~", each.key)[1]}"
  }

  all_instances_config {
    metadata = merge({
      block-project-ssh-keys  = "True"
      enable-extended-ui      = "TRUE"
      enable-guest-attributes = "TRUE"
      enable-os-inventory     = "TRUE"
      enable-osconfig         = "TRUE"
      enable-oslogin          = "TRUE"
      startup-script          = "gsutil -m cp ${var.cluster_startup_script}"
      proxy-mode              = "none"
      service_account         = local.service_account
    })
    labels = local.cluster_configuration
  }

  target_size = each.value

  # auto_healing_policies {
  #   health_check      = google_compute_health_check.autohealing.id
  #   initial_delay_sec = 300
  # }

  lifecycle {
    precondition {
      condition     = data.google_compute_region_instance_template.head_vm.disk[0].source_image == data.google_compute_region_instance_template.worker_node[each.key].disk[0].source_image
      error_message = "ERROR: The Cluster head and worker node(s) need to run the same Operating System (OS) Image. Right now, head node '${data.google_compute_region_instance_template.head_vm.name}' has the following OS Image: '${data.google_compute_region_instance_template.head_vm.disk[0].source_image}' and worker node template '${each.key}' has the following OS Image: '${data.google_compute_region_instance_template.worker_node[each.key].disk[0].source_image}'. The worker node does not match the head node. Please update the worker node template to match the head node."
    }
  }

  depends_on = [
    google_compute_instance_from_template.head_vm,
    data.google_compute_region_instance_template.worker_node
  ]
}
