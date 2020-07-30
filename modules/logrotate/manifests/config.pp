class logrotate::config {
    $conf_dir  = $logrotate::vars::conf_dir
    $retention = $logrotate::vars::retention

    file {
	"Prepare Logrotate for further configuration":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $conf_dir;
	"Install Logrotate main configuration":
	    content => template("logrotate/logrotate.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/logrotate.conf",
	    require => File["Prepare Logrotate for further configuration"];
    }

    each([ "alternatives", "btmp", "noderig", "wtmp" ]) |$f| {
	file {
	    "Purges spurious $f logrotate configuration":
		ensure => absent,
		path   => "/etc/logrotate.d/$f";
	}
    }
}
