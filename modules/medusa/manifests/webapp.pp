class medusa::webapp {
    $rdomain = $medusa::vars::rdomain
    $web_dir = $medusa::vars::web_dir

    if ($domain != $rdomain) {
	$ldapauth = false
	$reverse  = "$fqdn.$rdomain"
	$aliases  = [ "medusa.$rdomain", "tvschedule.$rdomain", "tvschedule.$domain", $reverse ]
    } else {
	include apache

	$ldapauth = "pubonly"
	$reverse  = false
	$aliases  = [ "tvschedule.$domain" ]
    }

    if (defined(Class["apache"])) {
	apache::define::vhost {
	    "medusa.$domain":
		add_xff_headers => true,
		aliases         => $aliases,
		app_port        => 8086,
		csp_name        => "medusa",
		deny_frames     => true,
		require         => Common::Define::Service["medusa"],
		vhostldapauth   => $ldapauth,
		vhostsource     => "medusa",
		with_reverse    => $reverse;
	}

	Class["apache"]
	    -> File["Prepare medusa web directory"]
    } else {
	include nginx

	nginx::define::vhost {
	    "medusa.$domain":
		add_xff_headers => true,
		aliases         => $aliases,
		app_port        => 8086,
		csp_name        => "medusa",
		deny_frames     => true,
		require         => Common::Define::Service["medusa"],
		vhostldapauth   => false,
		vhostsource     => "medusa",
		with_reverse    => $reverse;
	}

	Class["nginx"]
	    -> File["Prepare medusa web directory"]
    }

    file {
	"Prepare medusa web directory":
	    ensure  => directory,
	    group   => $medusa::vars::runtime_group,
	    mode    => "0755",
	    owner   => $medusa::vars::runtime_user,
	    path    => $web_dir,
	    require => User[$medusa::vars::runtime_user];
	"Prepare medusa store directory":
	    ensure  => directory,
	    group   => $medusa::vars::runtime_group,
	    mode    => "0755",
	    notify  => Service["medusa"],
	    owner   => $medusa::vars::runtime_user,
	    path    => "$web_dir/store",
	    require => File["Prepare medusa web directory"];
    }
}
