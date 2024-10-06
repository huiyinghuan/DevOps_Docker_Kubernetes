terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

provider "kubernetes" {
  host                   = digitalocean_kubernetes_cluster.k8s-do-terraform.endpoint
  cluster_ca_certificate = base64decode(digitalocean_kubernetes_cluster.k8s-do-terraform.kube_config[0].cluster_ca_certificate)
  token                  = digitalocean_kubernetes_cluster.k8s-do-terraform.kube_config[0].token
}

# Create a DigitalOcean Kubernetes cluster
resource "digitalocean_kubernetes_cluster" "k8s-do-terraform" {
  name    = var.cluster_name
  region  = var.region
  version = var.k8s_version

  node_pool {
    name       = "worker-node-pool"
    size       = "s-2vcpu-2gb"
    auto_scale = true
    min_nodes  = 2
    max_nodes  = 3
  }
}

# Frontend Kubernetes deployment
resource "kubernetes_deployment" "frontend_deployment" {
  metadata {
    name      = "frontend-app"
    namespace = "default"
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "frontend-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "frontend-app"
        }
      }

      spec {
        container {
          name  = "frontend-container"
          image = "hhylalala/reactjs-frontend:1.0"  # Replace with your frontend Docker image

          port {
            container_port = 3000
          }

          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }

            requests = {
              cpu    = "200m"
              memory = "256Mi"
            }
          }
            # Health check for readiness (if applicable)
          readiness_probe {
            http_get {
              path = "/"  # Ensure this matches your app's health check endpoint
              port = 3000
            }
            initial_delay_seconds = 5
            period_seconds        = 10
          }
        }
      }
    }
  }
}

# Backend Kubernetes deployment
resource "kubernetes_deployment" "backend_deployment" {
  metadata {
    name      = "backend-app"
    namespace = "default"
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "backend-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "backend-app"
        }
      }

      spec {
        container {
          name  = "backend-container"
          image = "hhylalala/go-backend:1.0"  # Replace with your backend Docker image

          port {
            container_port = 8080
          }

          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }

            requests = {
              cpu    = "200m"
              memory = "256Mi"
            }
          }
        }
      }
    }
  }
}

# Frontend service to expose the frontend deployment
resource "kubernetes_service" "frontend_service" {
  metadata {
    name      = "frontend-app-service"
    namespace = "default"
  }

  spec {
    selector = {
      app = "frontend-app"
    }

    port {
      port        = 80
      target_port = 3000
    }

    type = "LoadBalancer"  # This will create an external IP for the frontend service
  }
}

# Backend service to expose the backend deployment
resource "kubernetes_service" "backend_service" {
  metadata {
    name      = "backend-app-service"
    namespace = "default"
  }

  spec {
    selector = {
      app = "backend-app"
    }

    port {
      port        = 8080
      target_port = 8080
    }

    type = "ClusterIP"  # This will create an external IP for the backend service
  }
}
