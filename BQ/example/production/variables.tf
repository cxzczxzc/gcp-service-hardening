variable "dataset_name" {
  description = "Friendly name for the dataset being provisioned."
  type        = string
  default     = null
}

variable "project_id" {
  description = "Project where the dataset and table are created"
  type        = string
}


variable "tables" {
  description = "A list of objects which include table_id, table_name, schema, clustering, time_partitioning, range_partitioning, expiration_time and labels."
  default     = []
  type = list(object({
    table_id    = string,
    description = optional(string),
    table_name  = optional(string),
    schema      = string,
    clustering  = list(string),
    time_partitioning = object({
      expiration_ms            = string,
      field                    = string,
      type                     = string,
      require_partition_filter = bool,
    }),
    range_partitioning = object({
      field = string,
      range = object({
        start    = string,
        end      = string,
        interval = string,
      }),
    }),
    expiration_time = string,
    labels          = map(string),
  }))
}


variable "views" {
  description = "A list of objects which include view_id and view query"
  default     = []
  type = list(object({
    view_id        = string,
    description    = optional(string),
    query          = string,
    use_legacy_sql = bool,
    labels         = map(string),
  }))
}