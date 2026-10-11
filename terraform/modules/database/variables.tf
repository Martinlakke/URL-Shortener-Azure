variable "name_suffix" {
    type = string
}

variable "unique_suffix" {
    description = "Caracteres aleatorios para que el nombre sea único"
    type = string
}

variable "location" {
    type = string
}

variable "resource_group_name" {
  type = string
}

variable "vnet_id" {
  description = "Red a la que se enlaza la agenda DNS privada"
  type        = string
}

variable "subnet_id" {
  description = "Subred delegada donde vive el servidor"
  type        = string
}

variable "admin_login" {
  type    = string
  default = "pgadmin"
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "database_name" {
  type    = string
  default = "urlshortener"
}

variable "tags" {
  type    = map(string)
  default = {}
}