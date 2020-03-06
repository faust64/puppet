class sabnzbd::webapp {
    $conf_dir = $sabnzbd::vars::conf_dir
    $rdomain  = $sabnzbd::vars::rdomain

    common::define::package {
	"sabyenc":
	    provider => "pip",
	    require  => Class[Common::Tools::Pip];
    }

    if ($domain != $rdomain) {
	$dreverse = "downloads.$domain"
	$reverse  = "$fqdn.$domain"
	$aliases  = [ $reverse, "sabnzb.$rdomain", "sabnzbd.$rdomain", "sabnzb.$domain", "sabnzbd.$rdomain" ]
	$daliases = [ $dreverse, "downloads.$rdomain" ]
    } else {
	include apache

	$apachecnf = $apache::vars::conf_dir
	$aliases   = false
	$daliases  = false
	$dreverse  = false
	$reverse   = false

# can't re-define/need to find a more elegant way requesting certificates,
#	certbot::define::wrap {
#	    $apache::vars::service_name:
#		aliases => $aliases,
#		reqfile => "Prepare apache ssl directory",
#		within  => "$apachecnf/ssl";
#	}
    }

    if (defined(Class["apache"])) {
	apache::define::vhost {
	    "sab.$domain":
		aliases       => $aliases,
		app_port      => 8081,
		csp_name      => "sabnzbd",
		require       => Common::Define::Service[$sabnzbd::vars::service_name],
		vhostsource   => "sabnzbd",
		with_reverse  => $reverse;
# FIXME: certificate path
#	    "downloads.$domain":
#		aliases       => $daliases,
#		app_root      => "$conf_dir/downloads/complete",
#		require       => File["Prepare Sabnzbd downloads completed directory"],
#		with_reverse  => $dreverse;
	}
    } else {
	include nginx

	nginx::define::vhost {
	    "sab.$domain":
		aliases       => $aliases,
		app_port      => 8081,
		csp_name      => "sabnzbd",
		require       => Common::Define::Service[$sabnzbd::vars::service_name],
		vhostldapauth => false,
		vhostsource   => "sabnzbd",
		with_reverse  => $reverse;
	    "downloads.$domain":
		aliases       => $daliases,
		app_root      => "$conf_dir/downloads/complete",
		autoindex     => true,
		require       => File["Prepare Sabnzbd downloads completed directory"],
		vhostldapauth => false,
		with_reverse  => $dreverse;
	}
    }
}
