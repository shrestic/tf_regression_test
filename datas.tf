data "google_project" "project" {
}

data "google_storage_bucket_object_content" "storage_bucket_configuration" {
  name   = "service_catalog_configuration"
  bucket = "config-${local.env_hash}"
}

data "google_storage_bucket_object_content" "compute_engine_reservations" {
  name   = "shielded_vm/playbooks/reservations/compute_engine_reservations.json"
  bucket = "aif_shared_bucket_${local.subproduct}_00"
}

# gs://shared-aif-bucket-c3ed/requirements.txt
data "google_storage_bucket_object_content" "cluster_python_requirements_file" {
  count = local.file_python_requirements == "" ? 0 : 1

  name   = split("/", local.file_python_requirements)[3]
  bucket = split("/", local.file_python_requirements)[2]
}

# gs://shared-aif-bucket-c3ed/bash-script.sh
data "google_storage_bucket_object_content" "cluster_bash_script_file" {
  count = local.file_bash_script == "" ? 0 : 1

  name   = split("/", local.file_bash_script)[3]
  bucket = split("/", local.file_bash_script)[2]
}
