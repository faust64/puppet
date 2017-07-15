class rsyslog::rsyslog {
    $conf_dir = $rsyslog::vars::conf_dir

    if ($rsyslog::vars::no_local_log) {
	$src = "min"
    } else { $src = "local" }

    file {
	"Install rsyslog local configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0600",
	    notify  => Service[$rsyslog::vars::service_name],
	    owner   => root,
	    path    => "$conf_dir/rsyslog.d/00_local.conf",
	    require => File["Prepare rsyslog for further configuration"],
	    source  => "puppet:///modules/rsyslog/$src.conf";
    }
}
