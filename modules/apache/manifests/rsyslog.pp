class apache::rsyslog {
    include rsyslog::imfile

    $conf_dir = $apache::vars::rsyslog_conf_dir
    $log_dir  = $apache::vars::log_dir
    $version  = $apache::vars::rsyslog_version

    file {
	"Install apache rsyslog main configuration":
	    content => template("apache/rsyslog.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0600",
	    notify  => Service[$apache::vars::rsyslog_service_name],
	    owner   => root,
	    path    => "$conf_dir/rsyslog.d/10_apache_defaults.conf",
	    require => File["Prepare rsyslog for further configuration"];
    }
}
