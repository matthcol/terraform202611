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

resource "docker_image" "others" {
    for_each = toset([ for c in var.container_ter_ports: c.image ])

    name = each.value
}

# TODO: fusioner toutes les images dans un seul ensemble
#       definir des variables intermediaires (locals)

resource "docker_container" "echo" {
    for_each = var.container_names

    name = each.value  # or each.key pour un set
    image = docker_image.echo.image_id
}

resource "docker_container" "component" {
    for_each = var.container_bis_ports

    name = each.key
    image = docker_image.echo.image_id
    command = ["-text=${each.key} listening on ${each.value}, count = ${length(var.container_bis_ports)}"]
    ports {
        internal = 5678
        external = each.value
    }
}


resource "docker_container" "component_ter" {
    for_each = var.container_ter_ports

    name = each.key
    image =  each.value.image  # docker_image.echo.image_id
    ports {
        internal = each.value.exposed_port
        external = each.value.port
    }
}