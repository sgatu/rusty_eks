resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  namespace  = "devops"
  values     = ["${file(format("%s/config/jenkins/values.yaml", path.module))}"]
  set_sensitive {
    name  = "controller.adminUser"
    value = var.admin_user
  }

  set_sensitive {
    name  = "controller.adminPassword"
    value = var.admin_password
  }
}
