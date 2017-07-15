class rsyslog::tls {
    $conf_dir = $rsyslog::vars::conf_dir

    file {
	"Prepare rsyslog for tls configuration directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "$conf_dir/rsyslog.tls",
	    require => File["Prepare rsyslog for further configuration"];
    }

    pki::define::wrap {
	$rsyslog::vars::service_name:
	    ca      => "log",
	    group   => lookup("gid_zero"),
	    mode    => "0640",
	    owner   => root,
	    reqfile => "Prepare rsyslog for further configuration",
	    within  => "$conf_dir/rsyslog.tls";
    }
}
