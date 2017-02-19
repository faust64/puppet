class squid::logrotate {
    $log_dir       = $squid::vars::log_dir
    $runtime_group = $squid::vars::runtime_group
    $runtime_user  = $squid::vars::runtime_user
    $service_name  = $squid::vars::service_name

    file {
	"Install squid logrotate configuration":
	    content => template("squid/logrotate.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/logrotate.d/$service_name",
	    require => File["Prepare Logrotate for further configuration"];
    }
}
