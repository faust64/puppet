class mongodb::logrotate {
    $log_dir = $mongodb::vars::log_dir
    $rotate  = $mongodb::vars::log_retention

    file {
	"Install mongodb logrotate configuration":
	    content => template("mongodb/logrotate.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/logrotate.d/mongodb-server",
	    require => File["Prepare Logrotate for further configuration"];
    }
}
