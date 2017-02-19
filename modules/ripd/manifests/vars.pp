class ripd::vars {
    $nagios_runtime_user     = hiera("nagios_runtime_user")
    $rip_auth                = hiera("rip_auth")
    $rip_authid              = hiera("rip_authid")
    $rip_authkey             = hiera("rip_authkey")
    $rip_conf_dir            = hiera("rip_conf_dir")
    $rip_map                 = hiera("rip_map")
    $rip_no_redistribute     = hiera("rip_no_redistribute")
    $rip_redistribute        = hiera("rip_redistribute")
    $rip_service_name        = hiera("rip_service_name")
    $rip_splithorizon_method = hiera("rip_splithorizon_method")
    $sudo_conf_dir           = hiera("sudo_conf_dir")
}
