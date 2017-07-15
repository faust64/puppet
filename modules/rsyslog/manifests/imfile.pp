class rsyslog::imfile {
    $conf_dir = lookup("rsyslog_conf_dir")
    $version  = lookup("rsyslog_version")

    file {
	"Load rsyslog imfile module":
	    content => template("rsyslog/imfile.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0600",
	    notify  => Service[lookup("rsyslog_service_name")],
	    owner   => root,
	    path    => "$conf_dir/rsyslog.d/02_imfile.conf",
	    require => File["Prepare rsyslog for further configuration"];
    }
}
