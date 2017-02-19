class asterisk::rsyslog {
    include rsyslog::imfile

    $conf_dir = $asterisk::vars::rsyslog_conf_dir
    $version  = $asterisk::vars::rsyslog_version

    file {
	"Install asterisk rsyslog main configuration":
	    content => template("asterisk/rsyslog.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0600",
	    notify  => Service[$asterisk::vars::rsyslog_service_name],
	    owner   => root,
	    path    => "$conf_dir/rsyslog.d/14_asterisk.conf",
	    require => File["Prepare rsyslog for further configuration"];
    }
}
