variable subscription_id {
  type      = string
  default   = "5829e5b8-4cfc-4f19-b681-ff3198b496d8"
  sensitive = true
}
variable "tenant_id" {
  type      = string
  default   = "6bba8a86-1e4b-4687-800e-26dadadbbc69"
  sensitive = true
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
    default = "	116.90.103.7"
}
variable vm_size {
    default = "standard_b2s_v2"
}
variable vm_username {
    default = "azureuser"
}