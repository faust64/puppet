class nginx::rsyslog {
    include rsyslog::imfile

    $conf_dir = $nginx::vars::rsyslog_conf_dir
    $log_dir  = $nginx::vars::log_dir
    $version  = $nginx::vars::rsyslog_version

    file {
	"Install nginx rsyslog main configuration":
	    content => template("nginx/rsyslog.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0600",
	    notify  => Service[$nginx::vars::rsyslog_service_name],
	    owner   => root,
	    path    => "$conf_dir/rsyslog.d/10_nginx_defaults.conf",
	    require => File["Prepare rsyslog for further configuration"];
    }
}
