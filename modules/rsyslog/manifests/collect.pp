class rsyslog::collect {
    $collect      = $rsyslog::vars::listen
    $conf_dir     = $rsyslog::vars::conf_dir
    $do_not_store = $rsyslog::vars::do_not_store
    $do_relp      = $rsyslog::vars::do_relp
    $do_tcp       = $rsyslog::vars::do_tcp
    $do_tls       = $rsyslog::vars::do_tls
    $do_udp       = $rsyslog::vars::do_udp
    $store_dir    = $rsyslog::vars::store_dir

    if ($collect) {
	file {
	    "Install rsyslog collect configuration":
		content => template("rsyslog/collect.erb"),
		group   => lookup("gid_zero"),
		mode    => "0600",
		notify  => Service[$rsyslog::vars::service_name],
		owner   => root,
		path    => "$conf_dir/rsyslog.d/97_collect.conf",
		require => File["Prepare rsyslog for further configuration"];
	}
    } else {
	file {
	    "Purge rsyslog collect configuration":
		ensure  => absent,
		notify  => Service[$rsyslog::vars::service_name],
		path    => "$conf_dir/rsyslog.d/97_collect.conf",
		require => File["Prepare rsyslog for further configuration"];
	}
    }
}
