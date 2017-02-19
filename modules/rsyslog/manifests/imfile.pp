class rsyslog::imfile {
    $conf_dir = hiera("rsyslog_conf_dir")
    $version  = hiera("rsyslog_version")

    file {
	"Load rsyslog imfile module":
	    content => template("rsyslog/imfile.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0600",
	    notify  => Service[hiera("rsyslog_service_name")],
	    owner   => root,
	    path    => "$conf_dir/rsyslog.d/02_imfile.conf",
	    require => File["Prepare rsyslog for further configuration"];
    }
}
