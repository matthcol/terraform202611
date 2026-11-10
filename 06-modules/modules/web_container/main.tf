# fichier principal module web_container
terraform {
  required_providers {
    docker = {
        source = "kreuzwerker/docker"
        # pas de version, à faire au niveau du principal
    }
  }
}


resource "docker_container" "web" {
    image = var.image_id
    name = "web-${var.container_name_suffix}"
    ports {
        internal = var.internal_port
        external = var.external_port
    }
}