class cups::logrotate {
    $log_dir = $cups::vars::log_dir

    file {
	"Install cups logrotate configuration":
	    content => template("cups/logrotate.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/logrotate.d/cups",
	    require => File["Prepare Logrotate for further configuration"];
    }
}
