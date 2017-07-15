class squid::rsyslog {
    include rsyslog::imfile

    $conf_dir = $squid::vars::rsyslog_conf_dir
    $log_dir  = $squid::vars::log_dir

    file {
	"Install squid rsyslog main configuration":
	    content => template("squid/rsyslog.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0600",
	    notify  => Service[$squid::vars::rsyslog_service_name],
	    owner   => root,
	    path    => "$conf_dir/rsyslog.d/09_squid.conf",
	    require => File["Prepare rsyslog for further configuration"];
    }
}
