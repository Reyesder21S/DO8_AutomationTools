server = false
data_dir = "/opt/consul"
bind_addr = "0.0.0.0"
advertise_addr = "{{ GetInterfaceIP \"enp0s8\" }}"
retry_join = ["192.168.56.10"] 
connect {
  enabled = true
}
ports {
  grpc = 8502
}