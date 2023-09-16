
  provider "kubernetes" {
    secret_suffix    = "patrice"
    config_path      = "~/.kube/config"
  }

terraform {
  required_version = ">= 0.13"

  required_providers {
    dockerhub = {
      source  = "BarnabyShearer/dockerhub"
      version = ">= 0.0.15"
    }

    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  alias = "first"
  host  = "unix:///var/run/docker.sock"
  registry_auth {
    address     = "registry-1.docker.io"
    config_file = pathexpand("~/.docker/config.json")
    username    = var.dockerhub.docker_user
    password    = var.dockerhub.docker_password
  }
}

provider "dockerhub" {
  username    = var.dockerhub.docker_user
  password    = var.dockerhub.docker_password
}



resource "docker_image" "image" {
  name = "registry-1.docker.io/patricehub/react_projet"
  build {
    context = "./Dockerfile"
    dockerfile = "./Dockerfile"
  }
}

resource "docker_registry_image" "image" {
  name          = docker_image.image.name
  keep_remotely = true
}


# Poussez l'image vers Docker Hub
resource "null_resource" "push_to_dockerhub" {
  triggers = {
    docker_image_id = docker_image.image.id
  }

  provisioner "local-exec" {
    command = "docker push ${docker_image.image.name}"
  }
}

 


resource "docker_container" "react_container" {
  name  = "first-ct"
  image = "patricehub/react_projet:latest"
  ports {
    internal = 22
    external = 8900
  }
}
