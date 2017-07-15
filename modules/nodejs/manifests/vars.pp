class nodejs::vars {
    $force_version = lookup("nodejs_force_version")
    $from_sources  = lookup("nodejs_from_sources")
    $pm2_home      = lookup("nodejs_pm2_home")
    $pm2_group     = lookup("nodejs_pm2_group")
    $pm2_user      = lookup("nodejs_pm2_user")
    $service_name  = lookup("nodejs_service_name")
    $sudo_conf_dir = lookup("sudo_conf_dir")
}
