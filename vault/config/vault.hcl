listener "tcp" {
  address     = "0.0.0.0:8200"
  # "Although the listener stanza disables TLS for this example, Vault should always be used with TLS in production to provide secure communication between clients and the Vault server. It requires a certificate file and key file on each Vault host."
  tls_disable = 1
}

storage "file" {
    path = "/vault/file"
}

# "This runs a Vault server using the file storage backend at path /vault/file, with a default secret lease duration of one week and a maximum of 30 days."
default_lease_ttl = "168h"
max_lease_ttl = "720h"
api_addr = "http://0.0.0.0:8200"
cluster_addr = "https://0.0.0.0:8201"
ui = true
