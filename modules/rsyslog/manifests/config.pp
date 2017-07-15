class rsyslog::config {
    $conf_dir = $rsyslog::vars::conf_dir
    $gid_adm  = $rsyslog::vars::gid_adm

    file {
	"Prepare rsyslog for further configuration":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$conf_dir/rsyslog.d";
	"Install rsyslog main configuration":
	    content => template("rsyslog/main.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    notify  => Service[$rsyslog::vars::service_name],
	    path    => "$conf_dir/rsyslog.conf";
    }
}
