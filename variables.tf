variable "cluster_name" {
  # description = "Name of the VM"
  description = "Enter a name for the cluster. The name can have 44 lowercase letters, digits, or hyphens. It must start and end with a lowercase letter or number and contain a MINIMUM of 3 characters."
  type        = string

  validation {
    condition     = can(regex("((^[a-z0-9])+[a-z0-9-]+([a-z0-9]$))", var.cluster_name))
    error_message = "Cluster name can have lowercase letters, digits, or hyphens. It must start and end with a lowercase letter or number and contain a MINIMUM of 3 characters."
  }

  validation {
    condition     = length(var.cluster_name) <= 44
    error_message = "Cluster name is too long. It must be 44 characters or less."
  }
}

# variable "create_regional_instance_group" {
#   description = ""
#   type        = bool
#   default     = false
# }

variable "zone" {
  description = "Ente the GCP zone for the cluster. Values must start with 'us-' (ex: us-central1-b). Changes to this field after initial deployment will result in the cluster being deleted and recreated."
  type        = string
  default     = "us-central1-a"

  validation {
    condition     = startswith(var.zone, "us-")
    error_message = "Valid values for zone must start with 'us-'."
  }
}

variable "cluster_type" {
  description = "Please select the type of cluster."
  type        = string
  default     = "ray"
}

variable "cluster_head_node_template" {
  description = "Enter template name for head node."
  type        = string
}

variable "cluster_worker_node_template_names" {
  description = "Enter a list of cluster worker node template followed by a comma and number of nodes needed. (i.e., worker-node-1,2)"
  type        = list(string)

  # validation {
  #   condition     = alltrue([for i in var.cluster_worker_node_template_names : can(regex("[a-z](?:[-a-z0-9]{0,61}[a-z0-9])?|[1-9][0-9]{0,19}", split(",", i)[0]))])
  #   error_message = "Template names must start with a lowercase letter followed by up to 62 lowercase letters, numbers, or hyphens, and cannot end with a hyphen."
  # }

  # validation {
  #   condition     = alltrue([for i in var.cluster_worker_node_template_names : can(split(",", i)[1] <= 1000)])
  #   error_message = "Value must be a number less than or equal to 1,000 nodes."
  # }
}

variable "cluster_mount_bucket" {
  description = "Enter the Cloud Storage bucket name for mounting to cluster"
  type        = string
}

variable "cluster_python_requirements_file" {
  description = "[OPTIONAL] Cluster Python requirements file to be installed on cluster. (Example: gs://shared-aif-bucket-xxxx/requirements.txt)"
  type        = string
  default     = ""

  validation {
    condition     = var.cluster_python_requirements_file == "" || startswith(var.cluster_python_requirements_file, "gs://")
    error_message = "Python requirements file must be a valid Cloud Storage URL (i.e. gs://...) or empty for no python requirements file provided."
  }
}

variable "cluster_bash_script_file" {
  description = "[OPTIONAL] Cluster Bash script to be installed on cluster. (Example: gs://shared-aif-bucket-xxxx/bash-script.sh)"
  type        = string
  default     = ""

  validation {
    condition     = var.cluster_bash_script_file == "" || startswith(var.cluster_bash_script_file, "gs://")
    error_message = "Cluster bash script file must be a valid Cloud Storage URL (i.e. gs://...) or empty for no bash script provided."
  }
}

# variable "autoscalar_startup_cron" {
#   description = "Cron job for running the cluster"
#   type        = string
#   default     = "*/15 07-15 * * *"
# }

# variable "autoscalar_shutdown_cron" {
#   description = "Cron job for shutting down the cluster"
#   type        = string
#   default     = "0 17 * * *"
# }

variable "cluster_startup_script" {
  description = "Do not adjust this field. This field is only enabled during preview phase of cluster."
  type        = string
  default     = "gs://cluster-startup/scripts/startup-script.sh /tmp/startup-script.sh && chmod +x /tmp/startup-script.sh && /tmp/startup-script.sh"
}
