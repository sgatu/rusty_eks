
resource "kubernetes_namespace" "devops" {
  metadata {
    annotations = {
      name = "devops"
    }
    name = "devops"
  }
}
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
  set_sensitive {
    name  = "credentials.deploy_key_id"
    value = local.git_key_secret_name
  }
  set_sensitive {
    name  = "credentials.seed_key_id"
    value = local.git_seed_secret_name
  }
  set_sensitive {
    name  = "controller.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/certificate-arn"
    value = var.domain_certificate_arn
  }
  set {
    name  = "controller.ingress.annotations.external-dns\\.alpha\\.kubernetes\\.io/hostname"
    value = var.domain
  }
  set {
    name  = "controller.ingress.hostName"
    value = var.domain
  }

  depends_on = [kubernetes_namespace.devops]
}

resource "tls_private_key" "git_key" {
  algorithm = "ED25519"
  provisioner "local-exec" {
    command = <<-EOT
      echo '${tls_private_key.git_key.private_key_openssh}' > ${local.git_key_path.private}; 
      echo '${tls_private_key.git_key.public_key_openssh}' > ${local.git_key_path.public}
    EOT
  }
}

resource "kubernetes_secret" "git_deploy_key" {
  metadata {
    name = local.git_key_secret_name
    labels = {
      "env"                                = "prod"
      "jenkins.io/credentials-type"        = "basicSSHUserPrivateKey"
      "jenkins.io/credentials-description" = "Jenkins-private-key-to-retrieve-git-repositories"
    }
    namespace = "devops"
  }
  data = {
    username   = "git"
    privateKey = data.local_file.deploy_ssh_key.content
  }
  depends_on = [tls_private_key.git_key]
}

resource "kubernetes_secret" "git_seed_key" {
  metadata {
    name = local.git_seed_secret_name
    labels = {
      "env"                                = "prod"
      "jenkins.io/credentials-type"        = "basicSSHUserPrivateKey"
      "jenkins.io/credentials-description" = "Jenkins-private-key-to-download-seed-repository"
    }
    namespace = "devops"
  }
  data = {
    username   = "git"
    privateKey = data.local_file.seed_ssh_key.content
  }
}
