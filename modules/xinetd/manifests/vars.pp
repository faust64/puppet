class xinetd::vars {
    $clients = lookup("icinga_livestatus_clients")
    $umask   = lookup("xinetd_umask")
}
