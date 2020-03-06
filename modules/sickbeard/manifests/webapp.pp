class sickbeard::webapp {
    $rdomain = $sickbeard::vars::rdomain
    $web_dir = $sickbeard::vars::web_dir

    if ($domain != $rdomain) {
	$ldapauth = false
	$reverse  = "$fqdn.$rdomain"
	$aliases  = [ "sickbeard.$rdomain", "sickbeard.$domain", "tvcalendar.$rdomain", "tvcalendar.$domain", $reverse ]
    } else {
	include apache

	$ldapauth = "pubonly"
	$reverse  = false
	$aliases  = false
    }

    if (defined(Class["apache"])) {
	apache::define::vhost {
	    "tvschedule.$domain":
		aliases       => $aliases,
		app_port      => 8082,
		csp_name      => "sickbeard",
		deny_frames   => true,
		require       => Common::Define::Service["sickbeard"],
		vhostldapauth => $ldapauth,
		vhostsource   => "app_proxy",
		with_reverse  => $reverse;
	}

	Class["apache"]
	    -> File["Prepare sickbeard web directory"]
    } else {
	include nginx

	nginx::define::vhost {
	    "tvschedule.$domain":
		aliases       => $aliases,
		app_port      => 8082,
		csp_name      => "sickbeard",
		deny_frames   => true,
		require       => Common::Define::Service["sickbeard"],
		vhostldapauth => false,
		vhostsource   => "app_proxy",
		with_reverse  => $reverse;
	}

	Class["nginx"]
	    -> File["Prepare sickbeard web directory"]
    }

    file {
	"Prepare sickbeard web directory":
	    ensure  => directory,
	    group   => $sickbeard::vars::runtime_group,
	    mode    => "0755",
	    owner   => $sickbeard::vars::runtime_user,
	    path    => $web_dir,
	    require => User[$sickbeard::vars::runtime_user];
	"Prepare sickbeard store directory":
	    ensure  => directory,
	    group   => $sickbeard::vars::runtime_group,
	    mode    => "0755",
	    notify  => Service["sickbeard"],
	    owner   => $sickbeard::vars::runtime_user,
	    path    => "$web_dir/store",
	    require => File["Prepare sickbeard web directory"];
    }
}
