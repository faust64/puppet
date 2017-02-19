class haproxy::rsyslog {
    $conf_dir     = $haproxy::vars::rsyslog_conf_dir
    $logs_dir     = $haproxy::vars::logs_dir
    $stats_listen = $haproxy::vars::stats_listen
    $stats_port   = $haproxy::vars::stats_port

    file {
	"Install HAproxy rsyslog configuration":
	    content => template("haproxy/rsyslog.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0600",
	    notify  => Service[$haproxy::vars::rsyslog_service_name],
	    owner   => root,
	    path    => "$conf_dir/rsyslog.d/17_haproxy.conf",
	    require => File["Prepare HAproxy for further configuration"];
	"Purge HAproxy default rsyslog configuration":
	    ensure  => absent,
	    force   => yes,
	    notify  => Service[$haproxy::vars::rsyslog_service_name],
	    path    => "$conf_dir/haproxy.conf",
	    require => File["Prepare HAproxy for further configuration"];
    }
}
