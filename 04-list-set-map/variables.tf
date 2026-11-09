variable "container_names" {
    type = set(string)
    default = ["echo-main", "echo-second", "echo-tiers"]
}

variable "container_bis_ports" {
    type = map(number)
    default = {
        api = 8080
        db = 3306
        front = 80
    }
}

variable "container_ter_ports" {
    type = map(object({
        port = number
        exposed_port = number
        image = string
    }))
    default = {
        api_ter = {
            port = 8081
            exposed_port = 80
            image = "nginx:alpine"
        }
        db_ter = {
            port = 3307
            exposed_port = 5678
            image = "hashicorp/http-echo:1.0"
        }
        front_ter = {
            port = 81
            exposed_port = 80
            image = "nginx:alpine"
        }
    }
}