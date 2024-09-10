variable "subscription_id" {
  type        = string
  default     = null
  sensitive   = true  # Can be provided via environment variables in Jenkins or passed as a variable
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
variable "resource_group_name" {
    default = "my-app-resources"
}
variable my_ip {
    default = "116.90.103.178"
}
variable "jenkins_ip" {
    default = "13.90.151.74"
}
variable vm_size {
    default = "standard_b2s_v2"
}
variable vm_username {
    default = "azureuser"
}