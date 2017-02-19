class xinetd::vars {
    $clients = hiera("icinga_livestatus_clients")
    $umask   = hiera("xinetd_umask")
}
