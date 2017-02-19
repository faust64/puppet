class git::rsyslog {
    include rsyslog::imfile

    $conf_dir = $git::vars::rsyslog_conf_dir
    $version  = $git::vars::rsyslog_version

    file {
	"Install git rsyslog main configuration":
	    content => template("git/rsyslog.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0600",
	    notify  => Service[$git::vars::rsyslog_service_name],
	    owner   => root,
	    path    => "$conf_dir/rsyslog.d/12_gitlab.conf",
	    require => File["Prepare rsyslog for further configuration"];
    }
}
