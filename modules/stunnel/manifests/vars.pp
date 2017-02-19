class stunnel::vars {
    $ciphers = hiera("stunnel_ciphers")
    $options = hiera("stunnel_options")
    $srvname = hiera("stunnel_service_name")
}
