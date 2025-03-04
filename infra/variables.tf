variable "project_name" {
  type = string
}

variable "image_name" {
  type = string
}

variable "cw_metric_resolution_min" {
  type = string
}

variable "task_cpu" {
  type = string
}

variable "task_memory" {
  type = string
}

variable "container_port" {
  type = number
}

variable "internet_gateway_id" {
  type = string
}

variable "certificate_arn" {
  type = string
}

variable "hosted_zone_name" {
  type = string
}

variable "subdomain_name" {
  type = string
}
