# IAM Permissions
resource "google_compute_instance_iam_member" "head_vm_os_login_user" {
  instance_name = google_compute_instance_from_template.head_vm.name
  zone          = local.zone
  project       = local.project_id
  role          = "roles/compute.osLogin"
  member        = "group:${local.project_iam_group_users}"
}

resource "google_compute_instance_iam_member" "head_vm_admin_os_login_user" {
  instance_name = google_compute_instance_from_template.head_vm.name
  zone          = local.zone
  project       = local.project_id
  role          = "roles/compute.osAdminLogin"
  member        = "group:${local.project_iam_group_super_users}"
}
