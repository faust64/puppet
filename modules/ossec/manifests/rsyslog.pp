class ossec::rsyslog {
    include rsyslog::imfile

    $ossec_dir = $ossec::vars::conf_dir
    $conf_dir  = $ossec::vars::rsyslog_conf_dir
    $version   = $ossec::vars::rsyslog_version

    file {
	"Install ossec rsyslog configuration":
	    content => template("ossec/rsyslog.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0600",
	    notify  => Service[$ossec::vars::rsyslog_service_name],
	    owner   => root,
	    path    => "$conf_dir/rsyslog.d/07_ossec.conf",
	    require => File["Prepare rsyslog for further configuration"];
    }
}
