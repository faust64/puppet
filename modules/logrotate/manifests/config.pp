class logrotate::config {
    $conf_dir  = $logrotate::vars::conf_dir
    $retention = $logrotate::vars::retention

    file {
	"Prepare Logrotate for further configuration":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $conf_dir;
	"Install Logrotate main configuration":
	    content => template("logrotate/logrotate.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/logrotate.conf",
	    require => File["Prepare Logrotate for further configuration"];
    }
}
