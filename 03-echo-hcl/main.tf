terraform {
  required_providers {
    docker = {
        source = "kreuzwerker/docker"
        version = "~> 4.0"
    }
  }
}

provider "docker" {

}

resource "docker_image" "echo" {
  name = "hashicorp/http-echo:latest"
}

resource "docker_container" "echo" {
  count = var.nb_containers
  image = docker_image.echo.image_id
  name = "echo${count.index}"
  command = ["-text=${var.message} depuis chez moi [${count.index + 1}/${var.nb_containers}]"]
  ports {
    internal = 5678
    external = 8090 + count.index
  }
}