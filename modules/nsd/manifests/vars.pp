class nsd::vars {
    $conf_dir           = lookup("nsd_conf_dir")
    $control_enabled    = lookup("nsd_control_enable")
    $control_listenaddr = lookup("nsd_control_listen_address")
    $control_listenport = lookup("nsd_control_listen_port")
    $listen_addr        = lookup("nsd_listen_address")
    $listen_port        = lookup("nsd_listen_port")
    $run_dir            = lookup("nsd_run_dir")
    $runtime_group      = lookup("nsd_runtime_group")
    $runtime_user       = lookup("nsd_runtime_user")
    $zones              = lookup("nsd_serve_domains")
    $zones_dir          = lookup("nsd_zones_dir")
}
