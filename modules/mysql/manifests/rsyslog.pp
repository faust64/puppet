class mysql::rsyslog {
    include rsyslog::imfile

    $conf_dir = $mysql::vars::rsyslog_conf_dir
    $version  = $mysql::vars::rsyslog_version

    file {
	"Install mysql rsyslog main configuration":
	    content => template("mysql/rsyslog.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0600",
	    notify  => Service[$mysql::vars::rsyslog_srvname],
	    owner   => root,
	    path    => "$conf_dir/rsyslog.d/08_mysql_defaults.conf",
	    require => File["Prepare rsyslog for further configuration"];
    }
}
