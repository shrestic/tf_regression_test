resource "google_storage_bucket_object" "cluster_python_requirements_file" {
  count = local.file_python_requirements == "" ? 0 : 1

  name    = "clusters/${local.cluster_name}/cluster_python_requirements_file"
  content = data.google_storage_bucket_object_content.cluster_python_requirements_file[0].content
  bucket  = "config-${local.env_hash}"
}

resource "google_storage_bucket_object" "cluster_bash_script_file" {
  count = local.file_bash_script == "" ? 0 : 1

  name    = "clusters/${local.cluster_name}/cluster_bash_script_file"
  content = data.google_storage_bucket_object_content.cluster_bash_script_file[0].content
  bucket  = "config-${local.env_hash}"
}
