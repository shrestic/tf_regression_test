#------------------------------------------------------------------------------
# Build a unique Shielded VM
#------------------------------------------------------------------------------

data "google_compute_region_instance_template" "head_vm" {
  name   = local.head_node_template
  region = local.region
}

resource "google_compute_instance_from_template" "head_vm" {
  name = local.head_node_name
  zone = local.zone

  source_instance_template = "projects/${local.project_id}/regions/${local.region}/instanceTemplates/${local.head_node_template}"

  // Override fields from instance template
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

  tags = local.network_tags
}
