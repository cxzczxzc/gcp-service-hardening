# pipeline_id - example: org-logs-[admin|network|prod|nonprod]
variable "pipeline_id" {
  description = "ID of the pipline being created, used for resource naming"
  type        = string
}

# service_account
variable "service_account" {
  description = "Service account which will get Subscription pubsub/subscriber role"
  type        = string
}

variable "topic_writer_identity" {
  description = "The identity of the sink writer service account to allow access to the topic"
  default     = ["domain:dnb.com"]
  type        = list(string)
}

variable "labels" {
  description = "Map of labels to apply to resources"
  type        = map(string)
  default     = {}
}
