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

# resource "docker_container" "echo1" {
#   image = docker_image.echo.image_id
#   name = "echo1"
#   command = ["-text=Bonjour depuis chez moi"]
#   ports {
#     internal = 5678
#     external = 8090
#   }
# }