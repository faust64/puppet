class x11vnc::vars {
    $contact             = hiera("x11vnc_contact")
    $homedir             = hiera("generic_home_dir")
    $service_dir         = hiera("service_dir")
}
