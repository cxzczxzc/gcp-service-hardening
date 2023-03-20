resource "kubernetes_ingress_v1" "example_ingress" {
  metadata {
    name = "example-ingress"
    annotations = {
      "kubernetes.io/ingress.class" = "gce-internal"
    }
  }

  spec {
    rule {
      http {
        path {
          backend {
            service {
              name = "myapp-1"
              port {
                number = 80
              }
            }
          }
          path = "/app1/*"
        }
      }
    }
  }
  depends_on = [
    kubernetes_service_v1.hostname_service
  ]
}

resource "kubernetes_service_v1" "hostname_service" {
  metadata {
    name = "myapp-1"
    annotations = {
      "cloud.google.com/neg" = "{\"ingress\": true}"
    }
  }
  spec {
    selector = {
      app = "hostname"
    }
    port {
      name        = "host1"
      port        = 80
      protocol    = "TCP"
      target_port = 9376
    }
    type = "NodePort"
  }

}

resource "kubernetes_deployment" "hostname_server" {
  metadata {
    name = "hostname-server"
    labels = {
      app = "hostname"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "hostname"
      }
    }

    template {
      metadata {
        labels = {
          app = "hostname"
        }
      }

      spec {
        container {
          image = "k8s.gcr.io/serve_hostname:v1.4"
          name  = "hostname-server"

          port {
            container_port = 9376
            protocol       = "TCP"
          }
        }
      }
    }
  }
}