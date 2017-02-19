class freeradius::logrotate {
    $log_dir      = $freeradius::vars::log_dir
    $service_name = $freeradius::vars::service_name

    file {
	"Install freeradius logrotate configuration":
	    content => template("freeradius/logrotate.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/logrotate.d/freeradius",
	    require => File["Prepare Logrotate for further configuration"];
    }
}
