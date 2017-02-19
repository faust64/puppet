class ssh::vars {
    $access_class      = hiera("access_class")
    $ciphers           = hiera("ssh_ciphers")
    $host_keys         = hiera("ssh_host_keys")
    $moduli_dir        = hiera("ssh_moduli_dir")
    $restrict_to       = hiera("ssh_tcp_wrappers")
    $ssh_keys_database = hiera("ssh_keys_database")
    $ssh_kex_algos     = hiera("ssh_kex_algorithms")
    $ssh_mac_algos     = hiera("ssh_mac_algorithms")
    $ssh_port          = hiera("ssh_port")
    $ssh_psk_auth      = hiera("ssh_password_authentication")
    $ssh_service_name  = hiera("ssh_service_name")
    $vlist_hosts_list  = hiera("vlist_hosts_list")
}
