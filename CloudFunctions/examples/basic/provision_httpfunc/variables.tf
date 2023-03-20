variable "project_id" {
  type        = string
  description = "Id of the project"
}

variable "region" {
  type        = string
  description = "region name"
}

variable "runtime" {
  type        = string
  description = "The runtime in which the function is going to run"
}

variable "available_memory_mb" {
  type        = number
  description = "Memory (in MB), available to the function."
}

variable "entry_point" {
  type        = string
  description = "Name of the function that will be executed when the Google Cloud Function is triggered"
}

variable "timeout" {
  type        = number
  description = "Timeout (in seconds) for the function"
}

variable "source_archive_object" {
  type        = string
  description = "The source archive object (file) in archive bucket."
}

variable "max_instances" {
  type        = number
  description = "The limit on the maximum number of function instances that may coexist at a given time."
  default     = 1
}

variable "min_instances" {
  type        = number
  description = "The limit on the minimum number of function instances that may coexist at a given time."
  default     = 1
}

variable "build_environment_variables" {
  type        = map(any)
  description = "key/value pairs that will be available as environment variables at build time."
  default     = {}
}

variable "environment_variables" {
  type        = map(any)
  description = "key/value pairs that will be set as environment variables."
  default     = {}
}

variable "secret_environment_variables" {
  type = list(object({
    name       = string
    project_id = string
    version    = string
    secret     = string
  }))
  description = "Keys from the secret manager that will be set as secret environment variables."
  default     = []
}

variable "service_account_email" {
  type        = string
  description = "Service account to run the function with"
  default     = null
}

#httpFunc
variable "httpfunc_account_id" {
  type        = string
  description = "Service account id to invoke cloud function"
}

variable "httpfunc_function-name" {
  type        = string
  description = "Name of the function"
}

variable "httpfunc_function-description" {
  type        = string
  description = "Description of the function"
}

variable "httpfunc_source_archive_bucket" {
  type        = string
  description = "The GCS bucket containing the zip archive which contains the function."
}

#pubsubFunc
variable "pubsubfunc_account_id" {
  type        = string
  description = "Service account id to invoke cloud function"
}

variable "pubsubfunc_function-name" {
  type        = string
  description = "Name of the function"
}

variable "pubsubfunc_function-description" {
  type        = string
  description = "Description of the function"
}

variable "pubsubfunc_source_archive_bucket" {
  type        = string
  description = "The GCS bucket containing the zip archive which contains the function."
}

variable "pubsubfunc_topic_name" {
  type        = string
  description = "Cloud pubsub topic name"
}

#storageFunc
variable "storagefunc_account_id" {
  type        = string
  description = "Service account id to invoke cloud function"
}

variable "storagefunc_function-name" {
  type        = string
  description = "Name of the function"
}

variable "storagefunc_function-description" {
  type        = string
  description = "Description of the function"
}

variable "storagefunc_source_archive_bucket" {
  type        = string
  description = "The GCS bucket containing the zip archive which contains the function."
}

variable "shared_constants_file" {
  description = "The constants file name, where the constant are stored as JSON file with key/values that Terraform can interpret."
  type        = string
  default     = "config.json"
  validation {
    condition     = can(regex("\\.json$", var.shared_constants_file))
    error_message = "The file name should end with a \".json\" extension."
  }
}

variable "shared_constants_environment" {
  description = "The environment name that we want to know about its constants.  Accepted values are \"sandbox\", \"nonprod\", or \"prod\"."
  type        = string
  validation {
    condition     = var.shared_constants_environment == "sandbox" || var.shared_constants_environment == "nonprod" || var.shared_constants_environment == "prod"
    error_message = "Accepted values are \"sandbox\", \"nonprod\", or \"prod\"."
  }
}

variable "shared_constants_gcs_bucket" {
  description = "The GCS bucket name that contains the constants file."
  type        = string
}

variable "shared_constants_region" {
  description = "The region name that we want to know about its constants.  Accepted values are \"asia-pacific\", \"europe\", or \"north-america\"."
  type        = string
  validation {
    condition     = var.shared_constants_region == "asia-pacific" || var.shared_constants_region == "europe" || var.shared_constants_region == "north-america"
    error_message = "Accepted values are \"asia-pacific\", \"europe\", or \"north-america\"."
  }
}
variable "environment" {
  type        = string
  description = "Application environment stage"
  default     = "non_prod"
  validation {
    condition     = contains(["non_prod", "prod"], var.environment)
    error_message = "Valid values for var: environment are (non_prod, prod)."
  }
}
