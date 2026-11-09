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

resource "docker_image" "nginx" {
    name = "nginx:alpine"
}

resource "docker_container" "hello" {
    image = docker_image.nginx.image_id
    name = "hello-nginx"
    ports {
        internal = 80
        external = 8080
    }
}