class pnp4nagios::vars {
    $apache_conf_dir     = hiera("apache_conf_dir")
    $apache_service_name = hiera("apache_service_name")
    $conf_dir            = hiera("pnp4nagios_conf_dir")
    $install_dir         = hiera("pnp4nagios_install_dir")
    $lib_dir             = hiera("pnp4nagios_lib_dir")
    $nagios_conf_dir     = hiera("nagios_conf_dir")
    $runtime_group       = hiera("nagios_runtime_group")
    $runtime_user        = hiera("nagios_runtime_user")
    $service_name        = hiera("pnp4nagios_service_name")
    $spool_dir           = hiera("pnp4nagios_spool_dir")
}
