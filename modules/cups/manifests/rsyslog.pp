class cups::rsyslog {
    include rsyslog::imfile

    $conf_dir = $cups::vars::rsyslog_conf_dir
    $log_dir  = $cups::vars::log_dir
    $version  = $cups::vars::rsyslog_version

    file {
	"Install cups rsyslog main configuration":
	    content => template("cups/rsyslog.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0600",
	    notify  => Service[$cups::vars::rsyslog_service_name],
	    owner   => root,
	    path    => "$conf_dir/rsyslog.d/18_cups_defaults.conf",
	    require => File["Prepare rsyslog for further configuration"];
    }
}
