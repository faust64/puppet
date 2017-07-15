class apache::logrotate {
    $log_dir  = $apache::vars::log_dir
    $rotate   = $apache::vars::rotate
    $rungroup = $apache::vars::log_group
    $runuser  = $apache::vars::log_user
    $srvname  = $apache::vars::service_name

    file {
	"Install apache logrotate configuration":
	    content => template("apache/logrotate.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/logrotate.d/$srvname",
	    require => File["Prepare Logrotate for further configuration"];
    }
}
