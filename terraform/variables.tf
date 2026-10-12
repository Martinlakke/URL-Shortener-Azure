variable "location" {
  description = "Región de Azure donde se crea todo"
  type        = string
  default     = "northeurope"
}

variable "project" {
  description = "Nombre del proyecto, usado en los nombres de los recursos"
  type        = string
  default     = "urlshortener"
}

variable "environment" {
  description = "Entorno: dev, pre o pro"
  type        = string
  default     = "dev"
}

variable "image_tag" {
  description = "Versión de la imagen de la app a desplegar"
  type        = string
  default     = "v2"
}

variable "github_repo" {
  description = "Repositorio de GitHub que puede desplegar (usuario/repo)"
  type        = string
  default     = "Martinlakke@35890712/URL-Shortener-Azure@1412295921"
}

variable "kv_admin_object_ids" {
  description = "Identidades que pueden gestionar los secretos de Key Vault"
  type        = map(string)
  default = {
    marc     = "c3c424aa-f497-4841-b865-fee5d9d4cbdc"
    pipeline = "818fa1ef-3d2e-4642-a0a3-907ff3f1101c"
  }
}