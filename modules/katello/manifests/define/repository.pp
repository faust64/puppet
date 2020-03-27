define katello::define::repository($authpass  = false,
				   $authuser  = false,
				   $debarchs  = [ "amd64" ],
				   $debcomps  = [ "main", "contrib", "non-free" ],
				   $debrels   = [ "buster" ],
				   $dkrname   = false,
				   $dkrtags   = false,
				   $ensure    = 'present',
				   $gpgkey    = false,
				   $httppub   = true,
				   $org       = $katello::vars::katello_org,
				   $product   = false,
				   $shortname = $name,
				   $sslverify = true,
				   $type      = 'yum',
				   $url       = false) {
    if ($ensure == 'present') {
	if ($authuser and $authpass) {
	    $autharg = " --upstream-password '$authpass' --upstream-username '$authuser'"
	} else { $autharg = "" }
	if ($gpgkey != false and $url != "rhsm") {
	    Katello::Define::Gpgkey[$gpgkey]
		-> Exec["Install Repository [$product/$shortname] $name"]

	    $gpgarg = " --gpg-key '$gpgkey'"
	} else { $gpgarg = "" }
	if ($httppub) {
	    $pubarg = " --publish-via-http yes"
	} else { $pubarg = " --publish-via-http no" }
	if ($sslverify) {
	    $sslarg = " --verify-ssl-on-sync yes"
	} else { $sslarg = " --verify-ssl-on-sync no" }

	if ($url == "rhsm") {
	    Katello::Define::Repositoryset[$name]
		-> Exec["Install Repository [$product/$shortname] $name"]

	    $cmdargs = [ "echo DUMMY" ]
	} elsif ($url == "offline" and
		 ($type == "deb" or $type == "file" or $type == "docker"
		  or $type == "yum")) {
	    $cmdargs = [ "hammer repository create --name '$shortname'",
			 "--content-type $type --product '$product'",
			 "--organization '$org'$autharg$gpgarg$pubarg" ]
	} elsif ($url != false and
		 ($type == "deb" or $type == "docker" or $type == "yum")) {
	    if ($type == 'yum') {
		$cmdargs = [ "hammer repository create --name '$shortname'",
			     "--content-type yum --download-policy immediate",
			     "--url $url$autharg$gpgarg --product '$product'",
			     "--http-proxy-policy none$pubarg$sslarg",
			     "--organization '$org'" ]
	    } elsif ($type == 'deb') {
		$cmdargs = [ "hammer repository create --name '$shortname'",
			     "--content-type deb$autharg$sslarg$pubarg",
			     "--url $url$gpgarg --product '$product'",
			     "--deb-architectures", $debarchs.join(','),
			     "--deb-components", $debcomps.join(','),
			     "--deb-releases", $debrels.join(','),
			     "--http-proxy-policy none --organization '$org'" ]
	    } else {
		if ($dkrname) {
		    $dkrarg = " --docker-upstream-name $dkrname"
		} else { $dkrarg = "" }
		if ($dkrtags) {
		    $wl     = $dkrtags.join(',')
		    $fltarg = " --docker-tags-whitelist '$wl'"
		} else { $fltarg = "" }
		$cmdargs = [ "hammer repository create --name '$shortname'",
			     "--content-type docker --url $url --product",
			     "'$product'$dkrarg$autharg$sslarg$pubarg$fltarg",
			     "--http-proxy-policy none --organization '$org'" ]
	    }
	} else { $cmdargs = false }

	if ($cmdargs) {
	    exec {
		"Install Repository [$product/$shortname] $name":
		    command     => $cmdargs.join(' '),
		    environment => [ 'HOME=/root' ],
		    onlyif      => "hammer repository list --organization '$org' --product '$product'",
		    path        => "/usr/bin:/bin",
		    require     =>
			[
			    Katello::Define::Downloadpolicy["main"],
			    Katello::Define::Product[$product]
			],
		    unless      => "hammer repository info --name '$shortname' --organization '$org' --product '$product'";
	    }

	    if ($url != "offline") {
		exec {
		    "Synchronizes Repository [$product/$shortname] $name":
			command     => "hammer repository synchronize --name '$shortname' --product '$product' --organization '$org'",
			environment => [ 'HOME=/root' ],
			onlyif      => "hammer repository info --name '$shortname' --product '$product' --organization '$org' | grep -E 'Status:.*Not Synced'",
			path        => "/usr/bin:/bin",
			require     => Exec["Install Repository [$product/$shortname] $name"],
			timeout     => 14400;
		}
	    }
	} else {
	    notify {
		"Could not create repository [$product/$shortname] $name":
		    message => "Unsupported configuration";
	    }
	}
    } else {
	exec {
	    "Drop Repository [$product/$shortname] $name":
		command     => "hammer repository delete --name '$shortname' --organization '$org' --product '$product'",
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer repository info --name '$shortname' --organization '$org' --product '$product'",
		path        => "/usr/bin:/bin",
		require     => File["Install hammer cli configuration"];
	}
    }
}
