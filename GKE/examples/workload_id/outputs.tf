output "job_demo_completions" {
  value = kubernetes_job.demo.spec[0].completions
}
