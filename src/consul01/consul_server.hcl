server = true
bootstrap_expect = 1
data_dir = "/opt/consul"
bind_addr = "0.0.0.0"
advertise_addr = "{{ GetInterfaceIP \"enp0s8\" }}" 
client_addr = "0.0.0.0"
ui_config {
  enabled = true
}
connect {
  enabled = true
}