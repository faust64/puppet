class rsyslog::store {
    $conf_dir        = $rsyslog::vars::conf_dir
    $do_ossec        = $rsyslog::vars::do_ossec
    $do_relp         = $rsyslog::vars::logstash_relp
    $do_tcp          = $rsyslog::vars::logstash_tcp
    $do_udp          = $rsyslog::vars::logstash_udp
    $filter_contains = $rsyslog::vars::flt_contains
    $filter_regexp   = $rsyslog::vars::flt_regexp
    $store_esearch   = $rsyslog::vars::store_esearch
    $store_logstash  = $rsyslog::vars::store_logstash

    if ($store_esearch or $store_logstash) {
	if ($store_esearch) {
	    $srctemplate = "esearch"
	} else {
	    $srctemplate = "logstash"
	}

	file {
	    "Install rsyslog store configuration":
		content => template("rsyslog/store-$srctemplate.erb"),
		group   => lookup("gid_zero"),
		mode    => "0600",
		notify  => Service[$rsyslog::vars::service_name],
		owner   => root,
		path    => "$conf_dir/rsyslog.d/98_store.conf",
		require => File["Prepare rsyslog for further configuration"];
	}
    } else {
	file {
	    "Purge rsyslog store configuration":
		ensure  => "absent",
		notify  => Service[$rsyslog::vars::service_name],
		path    => "$conf_dir/rsyslog.d/98_store.conf",
		require => File["Prepare rsyslog for further configuration"];
	}
    }
}
