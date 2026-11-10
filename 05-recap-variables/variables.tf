variable "port" {
    type = number
    default = 8080
  
}

variable "name" {
    type = string
    default = "echo"
}

variable "auto" {
    type = bool
    default = false
}

variable "list_port" {
    type = list(number)
    default = [80, 443]
}

variable "set_port" {
    type = set(number)
    default = [80, 443] # conversion implicite en set
}

locals {
    set_port_2 = toset([80, 443])  # conversion explicite
}

variable "map_containers" {
    type = map(object({
        name = string
        port = number
    }))
    default = {
        echo = {
            name = "echo01"
            port = 80
        }
        web = {
            name = "web01"
            port = 8080
        }
    }
}

variable "tuple_container" {
    type = tuple([string, number, string])
    default = ["echo02", 8090, "nginx:alpine"]
}

locals {
    container_port_a = var.tuple_container[1]
    container_port_b = var.map_containers["echo"]["port"]
    container_port_c = var.map_containers.web.port
}

variable "container_config" {
    type = object({
      name = string,
      port = optional(number, 80)
    })
}

variable "container_config_2" {
    type = object({
      name = string,
      port = optional(number, null)
    })
}