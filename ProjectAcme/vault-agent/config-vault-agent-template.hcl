pid_file = "/vault/ProjectAcme/vault-agent/pidfile"

vault {
  address = "http://vault:8200"
}

auto_auth {
  method {
    type = "approle"
    config = {
      role_id_file_path                   = "/vault/ProjectAcme/vault-agent/role-id"
      secret_id_file_path                 = "/vault/ProjectAcme/vault-agent/secret-id"
      remove_secret_id_file_after_reading = false
    }
  }

  sink {
    type = "file"

    config = {
      path = "/vault/ProjectAcme/vault-agent/token"
    }
  }
}

template {
  source      = "/vault/ProjectAcme/vault-agent/appsettings.ctmpl"
  destination = "/vault/ProjectAcme/appsettings.json"
}
