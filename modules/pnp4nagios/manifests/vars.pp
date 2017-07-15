class pnp4nagios::vars {
    $apache_conf_dir     = lookup("apache_conf_dir")
    $apache_service_name = lookup("apache_service_name")
    $conf_dir            = lookup("pnp4nagios_conf_dir")
    $install_dir         = lookup("pnp4nagios_install_dir")
    $lib_dir             = lookup("pnp4nagios_lib_dir")
    $nagios_conf_dir     = lookup("nagios_conf_dir")
    $runtime_group       = lookup("nagios_runtime_group")
    $runtime_user        = lookup("nagios_runtime_user")
    $service_name        = lookup("pnp4nagios_service_name")
    $spool_dir           = lookup("pnp4nagios_spool_dir")
}
