class relayd::vars {
    $conf_dir            = lookup("relayd_conf_dir")
    $nagios_runtime_user = lookup("nagios_runtime_user")
    $mailmx_ip           = lookup("mail_mx")
    $namecache_ip        = lookup("dns_ip")
    $relayd_interval     = lookup("relayd_interval")
    $relayd_prefork      = lookup("relayd_prefork")
    $relayd_timeout      = lookup("relayd_timeout")
    $reverse_ip          = lookup("reverse_ip")
    $sudo_conf_dir       = lookup("sudo_conf_dir")
    $webcache_ip         = lookup("squid_ip")
}
