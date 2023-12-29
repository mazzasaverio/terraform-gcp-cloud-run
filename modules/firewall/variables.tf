variable "network_name" {
  description = "The name of the network where the firewall rules will be applied."
  type        = string
}

variable "internal_traffic_source_range" {
  description = "Source IP ranges to allow for internal traffic."
  type        = string
}

variable "internet_access_source_ranges" {
  description = "Source IP ranges to allow for internet access."
  type        = list(string)
}
