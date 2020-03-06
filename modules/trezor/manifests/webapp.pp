class trezor::webapp {
    $rdomain  = $trezor::vars::rdomain

    if ($domain != $rdomain) {
	$dreverse = "wallet.$domain"
	$reverse  = "$fqdn.$domain"
	$aliases  = [ $reverse ]
	$daliases = [ $dreverse, "trezor.$rdomain" ]
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
	    "wallet.$domain":
		aliases       => $aliases,
		app_port      => 8000,
#		csp_name      => "trezorwallet",
#		require       => Common::Define::Service[##nodejsservice##],
		vhostldapauth => false,
		vhostsource   => "trezor",
		with_reverse  => $reverse;
	}
    } else {
	include nginx

	nginx::define::vhost {
	    "wallet.$domain":
		aliases       => $aliases,
		app_port      => 8000,
#		csp_name      => "trezorwallet",
#		require       => Common::Define::Service[##nodejsservice##],
		vhostldapauth => false,
		vhostsource   => "trezor",
		with_reverse  => $reverse;
	}
    }
}
