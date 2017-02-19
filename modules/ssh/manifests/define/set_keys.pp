define ssh::define::set_keys($credential = "undefined",
			     $ensure     = "present",
			     $fuckme     = "undefined",
			     $key        = "undefined",
			     $localid    = "root",
			     $pentagram  = "undefined",
			     $type       = "ssh-dss") {
    if (($srvtype == "vz" or $srvtype == "kvm" or $srvtype == "kvmvz"
	 or $srvtype == "xen") and $ssh::vars::vlist_hosts_list[$fqdn]) {
	$access = $ssh::vars::vlist_hosts_list[$fqdn]
    }
    else {
	$access = $ssh::vars::access_class
    }

    if !defined(Ssh_authorized_key[$name])
   and $ensure  == "present"
   and $key     != "undefined"
   and $localid != "anonymous"
   and $type    != "undefined"
   and (
	    (
		$credential == "interne"
	     or $fuckme     == "interne"
	    )
	or  (
		$access     == "dirtech"
	    and (
		    $credential == "dirtech"
		 or $fuckme     == "dirtech"
		)
	    )
	or  (
		$access     == "projet"
	    and (
		    $credential == "projet"
		 or $fuckme     == "projet"
		)
	    )
	or  (
		$access     == "hosting"
	    and (
		    $credential == "hosting"
		 or $fuckme     == "hosting"
		)
	    )
	or  (
		$access     == "openbar"
	    and (
		    $credential == "dirtech"
		 or $fuckme     == "dirtech"
		 or $credential == "hosting"
		 or $fuckme     == "hosting"
		 or $credential == "projet"
		 or $fuckme     == "projet"
		)
	    )
	) {
	ssh_authorized_key {
	    $name:
		user   => $localid,
		type   => $type,
		ensure => $ensure,
		key    => $key;
	}
    }
    else {
	ssh_authorized_key {
	    $name:
		user   => $localid,
		ensure => absent;
	}
    }
}
