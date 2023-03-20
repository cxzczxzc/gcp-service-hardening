# the most important output: Subscription ID and Topic ID - needed for Cribl config
output "subscription_id" {
  value = google_pubsub_subscription.cribl_pubsub_sub.id
}

output "topic_id" {
  value = google_pubsub_topic.cribl_pubsub_topic.id
}
