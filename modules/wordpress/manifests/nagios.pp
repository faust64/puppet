class wordpress::nagios {
    $usr_dir = $wordpress::vars::usr_dir

    if ($wordpress::vars::nagios_rdomain == true) {
	$srvname = $wordpress::vars::proxyname

	common::define::lined {
	    "Force nagios DNS resolution":
		line  => "$ipaddress	$srvname",
		path  => "/etc/hosts";
	}
    } else {
	$srvname = $wordpress::vars::srvname
    }

    file {
	"Install wordpress version.php":
	    content => template("wordpress/version.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$usr_dir/wp-version.php",
	    require => Apache::Define::Vhost[$wordpress::vars::srvname];
    }

    if ($wordpress::vars::listen_ports['ssl'] != false) {
	$port = $wordpress::vars::listen_ports['ssl']
	$args = [ "https://$srvname:$port/wp-version.php" ]
    } else {
	$port = $wordpress::vars::listen_ports['plain']
	$args = [ "http://$srvname:$port/wp-version.php" ]
    }

    nagios::define::probe {
	"wordpress":
	    description   => "$fqdn wordpress update status",
	    pluginargs    => $args,
	    servicegroups => "webservices",
	    use           => "jobs-service";
    }
}
