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

# ----------------------------
# variables 'resource' simples
# ----------------------------

resource "docker_image" "web" {
  name = "nginx:alpine"
}

resource "docker_image" "echo" {
  name = "hashicorp/http-echo"
}

resource "docker_container" "echo" {
  name = "echo01"
  image = docker_image.echo.image_id   # uses variable resource  <type resource>.<nom resource>
}

locals {
  container_name = docker_container.echo.name  # uses variable resource  <type resource>.<nom resource>
  first_port = var.port  # uses variable  var.<nom var>
  second_port = length(local.set_port_2) > 0 ? tolist(local.set_port_2)[0] : 80 # uses local variable  local.<nom var>
}

# ------------------------------------------------
# variables 'resource' multiples : count, for_each
# ------------------------------------------------

resource "docker_container" "web" {
    count = 2

    name = "web-${count.index}"
    image = docker_image.web.image_id
}

resource "docker_container" "api" {
    for_each = toset(["meteo", "market"])

    name = "api-${each.value}"
    image = docker_image.web.image_id
}

locals {
    web_name_0 = docker_container.web[0].name  # docker_container.web est une liste (count)
    web_count = length(docker_container.web)
    web_names = [for c in docker_container.web: c.name]

    api_meteo_name = docker_container.api["meteo"].name  # docker_container.api est une map (for_each)
    api_count = length(docker_container.api)
    api_names = [for key, c in docker_container.api: c.name]
}