class ssh::vars {
    $access_class      = lookup("access_class")
    $ciphers           = lookup("ssh_ciphers")
    $host_keys         = lookup("ssh_host_keys")
    $moduli_dir        = lookup("ssh_moduli_dir")
    $restrict_to       = lookup("ssh_tcp_wrappers")
    $ssh_keys_database = lookup("ssh_keys_database")
    $ssh_kex_algos     = lookup("ssh_kex_algorithms")
    $ssh_mac_algos     = lookup("ssh_mac_algorithms")
    $ssh_port          = lookup("ssh_port")
    $ssh_psk_auth      = lookup("ssh_password_authentication")
    $ssh_service_name  = lookup("ssh_service_name")
    $vlist_hosts_list  = lookup("vlist_hosts_list")
}
