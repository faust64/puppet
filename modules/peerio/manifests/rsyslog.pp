class peerio::rsyslog {
    $conf_dir = $peerio::vars::rsyslog_conf_dir
    $logs_dir = $peerio::vars::logs_dir

    file {
	"Install peerio rsyslog main configuration":
	    content => template("peerio/rsyslog.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0600",
	    notify  => Service[$peerio::vars::rsyslog_service_name],
	    owner   => root,
	    path    => "$conf_dir/rsyslog.d/20_peerio.conf",
	    require => File["Prepare rsyslog for further configuration"];
    }
}
