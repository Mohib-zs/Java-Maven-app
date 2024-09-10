variable "client_id" {
  description = "The Client ID of the Managed Identity to use for authentication"
  type        = string
  default     = null  # Can be provided via environment variables in Jenkins or passed as a variable
}
variable subnet_address {
    default = "10.0.1.0/24"
}
variable vnet_address {
    default = "10.0.0.0/16"
}
variable env_prefix {
    default = "dev"
}
variable location {
    default = "centralus"
}
variable my_ip {
    default = "116.90.103.24"
}
variable "jenkins_ip" {
    default = "52.179.82.101"
}
variable vm_size {
    default = "standard_b2s_v2"
}
variable vm_username {
    default = "azureuser"
}