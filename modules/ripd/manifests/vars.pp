class ripd::vars {
    $nagios_runtime_user     = lookup("nagios_runtime_user")
    $rip_auth                = lookup("rip_auth")
    $rip_authid              = lookup("rip_authid")
    $rip_authkey             = lookup("rip_authkey")
    $rip_conf_dir            = lookup("rip_conf_dir")
    $rip_map                 = lookup("rip_map")
    $rip_no_redistribute     = lookup("rip_no_redistribute")
    $rip_redistribute        = lookup("rip_redistribute")
    $rip_service_name        = lookup("rip_service_name")
    $rip_splithorizon_method = lookup("rip_splithorizon_method")
    $sudo_conf_dir           = lookup("sudo_conf_dir")
}
