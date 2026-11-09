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

# resources docker images
locals {
    # image en dur
    echo_image_name = "hashicorp/http-echo:latest"
    # image dynamiques
    dynamic_image_names = toset([ for c in var.container_ter_ports: c.image ])
    # toutes les images dédoublonnées
    all_image_names = setunion(local.dynamic_image_names, [local.echo_image_name])
}


resource "docker_image" "all" {
    for_each = local.all_image_names

    name = each.value
}


# resources containers
resource "docker_container" "echo" {
    for_each = var.container_names

    name = each.value  # or each.key pour un set
    image = docker_image.all[local.echo_image_name].image_id
}

resource "docker_container" "component" {
    for_each = var.container_bis_ports

    name = each.key
    image = docker_image.all[local.echo_image_name].image_id
    command = ["-text=${each.key} listening on ${each.value}, count = ${length(var.container_bis_ports)}"]
    ports {
        internal = 5678
        external = each.value
    }
}


resource "docker_container" "component_ter" {
    for_each = var.container_ter_ports

    name = each.key
    image =  docker_image.all[each.value.image].image_id
    ports {
        internal = each.value.exposed_port
        external = each.value.port
    }
}