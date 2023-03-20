data "google_compute_subnetwork" "shared_vpc_subnet" {
  name    = var.subnetwork
  project = var.host_project_id
  region  = var.region
}

locals {
  # Minimum set of required scopes
  # @see https://cloud.google.com/dataproc/docs/concepts/configuring-clusters/service-accounts#dataproc_vm_access_scopes
  required_sa_scopes = [
    "https://www.googleapis.com/auth/cloud.useraccounts.readonly",
    "storage-rw",
    "logging-write"
  ]
}


resource "google_dataproc_cluster" "dp_cluster" {
  provider = google-beta # We are using beta provider because currently the feature enable_http_port_access is available in beta version. 

  name    = var.cluster_name
  region  = var.region
  project = var.project_id
  labels  = var.labels

  cluster_config {
    staging_bucket = var.staging_bucket

    software_config {
      image_version       = var.image_version
      optional_components = var.optional_components
      override_properties = var.override_properties
    }

    dynamic "encryption_config" {
      for_each = tolist(var.kms_key_name)

      content {
        kms_key_name = encryption_config.value
      }
    }

    endpoint_config {
      enable_http_port_access = var.http_port_access
    }


    dynamic "initialization_action" {
      for_each = [for script in var.initialization_script : {
        script = script
      }]

      content {
        script      = initialization_action.value.script
        timeout_sec = var.initialization_timeout_sec
      }
    }

    gce_cluster_config {
      subnetwork       = data.google_compute_subnetwork.shared_vpc_subnet.self_link
      internal_ip_only = var.internal_ip_only
      tags             = var.tags
      zone             = var.zone
      metadata = {
        CONDA_PACKAGES         = var.conda_packages
        PIP_PACKAGES           = var.pip_packages
        block-project-ssh-keys = true
      }

      shielded_instance_config {
        enable_secure_boot          = true
        enable_vtpm                 = true
        enable_integrity_monitoring = true
      }

      service_account = var.service_account
      service_account_scopes = distinct(
        concat(local.required_sa_scopes, var.service_account_scopes)
      )
    }

    master_config {
      num_instances = var.master_ha ? 3 : 1
      machine_type  = var.master_instance_type

      disk_config {
        boot_disk_type    = var.master_disk_type
        boot_disk_size_gb = var.master_disk_size
        num_local_ssds    = var.master_local_ssd
      }
    }

    worker_config {
      machine_type = var.worker_instance_type

      disk_config {
        boot_disk_type    = var.worker_disk_type
        boot_disk_size_gb = var.worker_disk_size
        num_local_ssds    = var.worker_local_ssd
      }

      dynamic "accelerators" {
        for_each = var.worker_accelerator

        content {
          accelerator_count = accelerators.value.worker_accelerator.count
          accelerator_type  = accelerators.value.worker_accelerator.type
        }
      }
    }

    preemptible_worker_config {
      num_instances = var.preemptible_worker_min_instances
    }

    autoscaling_config {
      policy_uri = google_dataproc_autoscaling_policy.asp.name
    }
  }
}


resource "google_dataproc_autoscaling_policy" "asp" {
  project   = var.project_id
  policy_id = "${var.cluster_name}-policy"
  location  = var.region

  worker_config {
    min_instances = var.primary_worker_min_instances
    max_instances = var.primary_worker_max_instances
    weight        = 1
  }

  secondary_worker_config {
    min_instances = var.preemptible_worker_min_instances
    max_instances = var.preemptible_worker_max_instances
    weight        = 3
  }

  basic_algorithm {
    cooldown_period = var.cooldown_period

    yarn_config {
      graceful_decommission_timeout = var.graceful_decommission_timeout

      scale_up_factor                = var.scale_up_factor
      scale_up_min_worker_fraction   = var.scale_up_min_worker_fraction
      scale_down_factor              = var.scale_down_factor
      scale_down_min_worker_fraction = var.scale_down_min_worker_fraction
    }
  }
}
