class nodejs::vars {
    $force_version = hiera("nodejs_force_version")
    $from_sources  = hiera("nodejs_from_sources")
    $pm2_home      = hiera("nodejs_pm2_home")
    $pm2_group     = hiera("nodejs_pm2_group")
    $pm2_user      = hiera("nodejs_pm2_user")
    $service_name  = hiera("nodejs_service_name")
    $sudo_conf_dir = hiera("sudo_conf_dir")
}
