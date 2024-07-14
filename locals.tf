locals {
  cluster_configuration = {
    "bucket_mount" : var.cluster_mount_bucket
    "cluster_name" : local.cluster_name
    "cluster_type" : local.cluster_type
    "head_node_name" : local.head_node_name
    "head_node_template" : local.head_node_template
  }
  cluster_name                     = trimspace(var.cluster_name)
  cluster_type                     = trimspace(var.cluster_type)
  compute_engine_reservations_json = jsondecode(data.google_storage_bucket_object_content.compute_engine_reservations.content)
  hash                             = substr(data.google_project.project.id, -4, 0)
  head_node_name                   = "${local.cluster_name}-${local.cluster_type}-head"
  head_node_template               = trimspace(var.cluster_head_node_template)
  file_python_requirements         = trimspace(var.cluster_python_requirements_file)
  file_bash_script                 = trimspace((var.cluster_bash_script_file))
  network_host_project_id          = "HOSTPROJECTID"
  network_tags                     = ["${local.cluster_type}-cluster"]
  project_iam_group_super_users    = local.service_catalog_config_json.iam_groups_bindings.project_iam_group_super_users
  project_iam_group_users          = local.service_catalog_config_json.iam_groups_bindings.project_iam_group_users
  project_id                       = split("/", data.google_project.project.id)[1]
  region                           = "us-${split("-", var.zone)[1]}"
  repo                             = "%REPO_VALUE%" # solution repo populated by build process
  service_account                  = "gsa6-ce-prj-aif-${local.subproduct}-svm-${local.hash}@${local.project_id}.iam.gserviceaccount.com"
  service_catalog_config_json      = jsondecode(data.google_storage_bucket_object_content.storage_bucket_configuration.content)
  shared_bucket                    = data.google_project.project.labels["common_gcs_shared_bucket_name"]
  subproduct                       = "ENV_VALUE"       # ("n" or "p")
  version                          = "%VERSION_VALUE%" # solution version populated by build process
  zone                             = trimspace(var.zone)
  zone_suffix                      = split("-", local.zone)[2]

  compute_instance_templates = {
    for i, value in var.cluster_worker_node_template_names : "${i}~${trimspace(split(",", value)[0])}" => trimspace(split(",", value)[1])
  }

  labels = {
    billing_project    = local.project_id
    classification     = data.google_project.project.labels["classification"]
    configuration_item = data.google_project.project.labels["configuration_item"]
    data_owner         = data.google_project.project.labels["data_owner"]
    organization       = data.google_project.project.labels["organization"]
    pau                = data.google_project.project.labels["pau"]
    repo               = local.repo
    version            = local.version
  }

  # Customer environment config
  env_map = ({
    "" = {
      env_hash = "${local.hash}"
    },
    "dev" = {
      env_hash = "d-${local.hash}"
    },
    "test" = {
      env_hash = "t-${local.hash}"
    },
    "stage" = {
      env_hash = "s-${local.hash}"
    },
    "prod" = {
      env_hash = "p-${local.hash}"
    },
  })
  env        = lookup(data.google_project.project.labels, "environment", "")
  env_config = local.env_map[local.env]
  env_hash   = local.env_config["env_hash"]
}
