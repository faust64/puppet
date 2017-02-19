class relayd::vars {
    $conf_dir            = hiera("relayd_conf_dir")
    $nagios_runtime_user = hiera("nagios_runtime_user")
    $mailmx_ip           = hiera("mail_mx")
    $namecache_ip        = hiera("dns_ip")
    $relayd_interval     = hiera("relayd_interval")
    $relayd_prefork      = hiera("relayd_prefork")
    $relayd_timeout      = hiera("relayd_timeout")
    $reverse_ip          = hiera("reverse_ip")
    $sudo_conf_dir       = hiera("sudo_conf_dir")
    $webcache_ip         = hiera("squid_ip")
}
