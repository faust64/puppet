class nsd::vars {
    $conf_dir           = hiera("nsd_conf_dir")
    $control_enabled    = hiera("nsd_control_enable")
    $control_listenaddr = hiera("nsd_control_listen_address")
    $control_listenport = hiera("nsd_control_listen_port")
    $listen_addr        = hiera("nsd_listen_address")
    $listen_port        = hiera("nsd_listen_port")
    $run_dir            = hiera("nsd_run_dir")
    $runtime_group      = hiera("nsd_runtime_group")
    $runtime_user       = hiera("nsd_runtime_user")
    $zones              = hiera("nsd_serve_domains")
    $zones_dir          = hiera("nsd_zones_dir")
}
