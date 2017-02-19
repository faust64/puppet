define stunnel::define::tunnel($accept     = "127.0.0.1:65535",
			       $capki      = false,
			       $cafile     = false,
			       $certfile   = false,
			       $connect    = false,
			       $ciphers    = hiera("stunnel_ciphers"),
			       $keyfile    = false,
			       $options    = hiera("stunnel_options"),
			       $sslversion = "all") {
    if (! defined(Class[stunnel])) {
	include stunnel
    }

    if ($connect != false and $accept != false) {
	if ($capki) {
	    $true_cafile   = "/etc/stunnel/ssl/$name/server-chain.crt"
	    $true_certfile = "/etc/stunnel/ssl/$name/server.crt"
	    $true_keyfile  = "/etc/stunnel/ssl/$name/server.key"
	    if ($connect =~ /127\.0\.0\.1/) {
		$do = "all"
	    } else {
		$do = "ca"
	    }

	    stunnel::define::pkiwrap {
		$name:
		    ca => $capki,
		    do => $do;
	    }

	    Stunnel::Define::Pkiwrap[$name]
		-> File["Install stunnel $name configuration"]
	} elsif ($cafile) {
	    $true_cafile   = $cafile
	    $true_certfile = $certfile
	    $true_keyfile  = $keyfile
	} else {
	    $true_cafile   = "/etc/puppet/ssl/certs/ca.pem"
	    $true_certfile = "/etc/puppet/ssl/public_keys/$fqdn.pem"
	    $true_keyfile  = "/etc/puppet/ssl/private_keys/$fqdn.pem"
	}

	if ($true_cafile) {
	    file {
		"Install stunnel $name configuration":
		    content => template("stunnel/tunnel.erb"),
		    group   => hiera("gid_zero"),
		    mode    => "0644",
		    notify  => Service[hiera("stunnel_service_name")],
		    owner   => root,
		    path    => "/etc/stunnel/$name.conf",
		    require => File["Prepare stunnel for further configuration"];
	    }
	} else {
	    notify { "stunnel $name has no CA configured": }
	}
    } else {
	notify { "stunnel $name routes to nowhere": }
    }
}
