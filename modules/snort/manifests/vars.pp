class snort::vars {
    $conf_dir        = hiera("snort_conf_dir")
    $dns_ip          = hiera("dns_ip")
    $log_dir         = hiera("snort_log_dir")
    $mail_ip         = hiera("mail_ip")
    $netids          = hiera("office_netids")
    $snort_group     = hiera("snort_group")
    $snort_listen_if = hiera("snort_listen_if")
    $snort_user      = hiera("snort_user")
}
