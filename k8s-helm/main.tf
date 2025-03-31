resource "kubernetes_namespace" "test" {
  metadata {
    name = "test"
  }
}

resource "helm_release" "nginx" {
  name       = "bitnami-nginx"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "nginx"
  namespace  = "test"
  set {
    name  = "service.type"
    value = "ClusterIP"
  }

  set {
    name = "image.tag"
    value = "1.25.3-debian-11-r1"
  }

  lifecycle {
    ignore_changes = [set]
  }
}
