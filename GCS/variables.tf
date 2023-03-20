variable "name" {
  description = "The name of the bucket. Takes preference over prefix_name"
  type        = string
  default     = ""
}

variable "prefix_name" {
  description = "The prefix name of the bucket.  A random suffix will be generated. Conflicts with 'name' which takes precedence"
  type        = string
  default     = ""
}

variable "project_id" {
  description = "The ID of the project to create the bucket in."
  type        = string
}

variable "location" {
  description = "The location of the bucket."
  type        = string
  default     = "us-east4"
}

variable "storage_class" {
  description = "The Storage Class of the new bucket."
  type        = string
  default     = "STANDARD"

  validation {
    condition     = contains(["STANDARD", "MULTI_REGIONAL", "REGIONAL", "NEARLINE", "COLDLINE", "ARCHIVE"], var.storage_class)
    error_message = "Validation: storage class must be one of: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE."
  }
}

variable "labels" {
  description = "A set of key/value label pairs to assign to the bucket."
  type        = map(string)
  default     = null
}

variable "iam_members" {
  description = "The list of IAM members to grant permissions on the bucket. Inherits project permissions by default."
  type = list(object({
    role   = string
    member = string
  }))
  default = []
}

variable "cors" {
  description = "Configuration of CORS for bucket with structure as defined in https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket#cors."
  type        = any
  default     = []
}

variable "encryption" {
  description = "A Cloud KMS key that will be used to encrypt objects inserted into this bucket"
  type = object({
    default_kms_key_name = string
  })
  default = null
}

variable "lifecycle_rules" {
  description = "The bucket's Lifecycle Rules configuration."
  type = list(object({
    # Object with keys:
    # - type - The type of the action of this Lifecycle Rule. Supported values: Delete and SetStorageClass.
    # - storage_class - (Required if action type is SetStorageClass) The target Storage Class of objects affected by this Lifecycle Rule.
    action = any

    # Object with keys:
    # - age - (Optional) Minimum age of an object in days to satisfy this condition.
    # - created_before - (Optional) Creation date of an object in RFC 3339 (e.g. 2017-06-13) to satisfy this condition.
    # - with_state - (Optional) Match to live and/or archived objects. Supported values include: "LIVE", "ARCHIVED", "ANY".
    # - matches_storage_class - (Optional) Storage Class of objects to satisfy this condition. Supported values include: MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, STANDARD, DURABLE_REDUCED_AVAILABILITY.
    # - num_newer_versions - (Optional) Relevant only for versioned objects. The number of newer versions of an object to satisfy this condition.
    condition = any
  }))
  default = [{
    # Keep live object and two previous versions for 30 days (1 previous version indefinitely)
    action = {
      type = "Delete"
    }
    condition = {
      age                = 30
      with_state         = "ARCHIVED"
      num_newer_versions = 2
    }
  }]
}

variable "website" {
  type        = map(any)
  default     = {}
  description = "Map of website values. Supported attributes: main_page_suffix, not_found_page"
}

variable "notification_pubsub_topics" {
  type = map(object({
    topic               = string
    notification_events = list(string)

  }))
  default     = {}
  description = "Map including the topic name as a string and notification events as list of any of the following: OBJECT_FINALIZE, OBJECT_METADATA_UPDATE, OBJECT_DELETE, OBJECT_ARCHIVE."

  validation {
    condition = alltrue(flatten([
      for o in var.notification_pubsub_topics : [
        for event in o.notification_events :
        contains(["OBJECT_FINALIZE", "OBJECT_METADATA_UPDATE", "OBJECT_DELETE", "OBJECT_ARCHIVE"], event)
      ]
    ]))
    error_message = "Notification events must be a list of any of the following: OBJECT_FINALIZE, OBJECT_METADATA_UPDATE, OBJECT_DELETE, OBJECT_ARCHIVE."
  }
}

variable "environment" {
  type        = string
  description = "Project environment (prod, nonprod, sandbox)."

  validation {
    condition     = contains(["prod", "nonprod", "sandbox"], var.environment)
    error_message = "Environment must be one of the following: prod, nonprod, sandbox."
  }
}

variable "force_destroy" {
  type        = bool
  description = "When deleting a bucket, this boolean option will delete all contained objects when set to true. If this value is set to false and you try to delete a bucket that contains objects, Terraform will fail."
  default     = false
}
