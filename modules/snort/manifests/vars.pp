class snort::vars {
    $conf_dir        = lookup("snort_conf_dir")
    $daq_dir         = lookup("snort_daq_dir")
    $dns_ip          = lookup("dns_ip")
    $ignore_tcp      = lookup("snort_ignore_tcp_ports")
    $ignore_udp      = lookup("snort_ignore_udp_ports")
    $log_dir         = lookup("snort_log_dir")
    $mail_ip         = lookup("mail_ip")
    $netids          = lookup("office_netids")
    $snort_group     = lookup("snort_group")
    $snort_listen_if = lookup("snort_listen_if")
    $snort_user      = lookup("snort_user")
}
