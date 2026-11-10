variable "image_id" {
    type = string
}

variable "container_name_suffix" {
    type = string
    default = "01"
}

variable "internal_port" {
    type = number
    default = 80
}

variable "external_port" {
    type = number
    default = 80
}