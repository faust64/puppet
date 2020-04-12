define katello::define::subnet($base      = false,
			       $bootmode  = "DHCP",
			       $ensure    = 'present',
			       $domain    = false,
			       $dhcp_from = 150,
			       $dhcp_to   = 160,
			       $dns_prim  = false,
			       $dns_sec   = false,
			       $gateway   = false,
			       $loc       = $katello::vars::katello_loc,
			       $netmask   = false,
			       $network   = false,
			       $org       = $katello::vars::katello_org) {
    if ($ensure == 'present') {
	if ($dns_prim != false) {
	    $dnsone = $dns_prim
	} else { $dnsone = "1.1.1.1" }
	if ($dns_sec != false) {
	    $dnstoo = $dns_sec
	} else { $dnstoo = $dnsone }
	if ($gateway != false) {
	    $gw = $gateway
	} else { $gw = "$base.1" }
	if ($netmask != false) {
	    $nm = $netmask
	} else { $nm = "255.255.255.0" }
	if ($network != false) {
	    $nw = $network
	} else { $nw = "$base.0" }
	if ($bootmode != "DHCP") {
	    $bm = " --boot-mode Static"
	} else { $bm = " --boot-mode DHCP" }
	if ($base != false) {
	    $dfrom = "$base.$dhcp_from"
	    $dto   = "$base.$dhcp_to"
	} else {
	    $dfrom = "$name.$dhcp_from"
	    $dto   = "$name.$dhcp_to"
	}

	if ($domain != false) {
	    Katello::Define::Domain[$domain]
		-> Exec["Install Subnet $name"]

	    $dm = " --domains $domain"
	} else {
	    File["Install hammer cli configuration"]
		-> Exec["Install Subnet $name"]

	    $dm = ""
	}

	$cmdargs = [ "hammer subnet create --name '$name' --organizations",
		     "'$org' --locations '$loc'$dm --network $nw --mask $nm",
		     "--ipam 'Internal DB' --from $dfrom --to $dto",
		     "--dns-primary $dnsone --dns-secondary $dnstoo$bm" ]
	exec {
	    "Install Subnet $name":
		command     => $cmdargs.join(' '),
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer subnet list --organization '$org'",
		path        => "/usr/bin:/bin",
		unless      => "hammer subnet info --name '$name' --organization '$org' --location '$loc'";
	}
    } else {
	exec {
	    "Drop Subnet $name":
		command     => "hammer subnet delete --name '$name' --organization '$org' --location '$loc'",
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer subnet info --name '$name' --organization '$org' --location '$loc'",
		path        => "/usr/bin:/bin",
		require     => File["Install hammer cli configuration"];
	}
    }
}
