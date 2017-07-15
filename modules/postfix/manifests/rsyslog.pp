class postfix::rsyslog {
    $conf_dir  = $postfix::vars::rsyslog_conf_dir
    $spool_dir = $postfix::vars::spool_dir

    file {
	"Drop rsyslog postfix default configuration":
	    ensure  => absent,
	    force   => true,
	    notify  => Service[$postfix::vars::rsyslog_service_name],
	    path    => "$conf_dir/rsyslog.d/postfix.conf",
	    require => Package["postfix"];
	"Install rsyslog postfix listener":
	    content => template("postfix/rsyslog.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0600",
	    notify  => Service[$postfix::vars::rsyslog_service_name],
	    owner   => root,
	    path    => "$conf_dir/rsyslog.d/03_postfix.conf",
	    require => File["Prepare rsyslog for further configuration"];
    }
}
