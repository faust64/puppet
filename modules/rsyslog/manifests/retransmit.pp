class rsyslog::retransmit {
    $conf_dir   = $rsyslog::vars::conf_dir
    $do_relp    = $rsyslog::vars::do_relp
    $do_stunnel = $rsyslog::vars::via_stunnel
    $do_tcp     = $rsyslog::vars::do_tcp
    $do_tls     = $rsyslog::vars::do_tls
    $do_udp     = $rsyslog::vars::do_udp
    $retransmit = $rsyslog::vars::retransmit

    if ($retransmit) {
	file {
	    "Install rsyslog retransmit configuration":
		content => template("rsyslog/retransmit.erb"),
		group   => hiera("gid_zero"),
		mode    => "0600",
		notify  => Service[$rsyslog::vars::service_name],
		owner   => root,
		path    => "$conf_dir/rsyslog.d/99_forward.conf",
		require => File["Prepare rsyslog for further configuration"];
	}
    } else {
	file {
	    "Purge rsyslog retransmit configuration":
		ensure  => "absent",
		notify  => Service[$rsyslog::vars::service_name],
		path    => "$conf_dir/rsyslog.d/99_forward.conf",
		require => File["Prepare rsyslog for further configuration"];
	}
    }
}
