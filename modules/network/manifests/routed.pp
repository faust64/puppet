class network::routed {
    $mtu = $network::vars::default_mtu
    if ($network::vars::local_networks) {
	each($network::vars::local_networks) |$nic| {
	    $nicname = $nic['name']
	    if ($nic['netmsk']) {
		$fmask = $nic['netmsk']
	    } else {
		$fmask = false
	    }
	    if ($nic['addr']) {
		$faddr = $nic['addr']
	    } else {
		$faddr = false
	    }
	    if ($nic['netid']) {
		$fnetid = $nic['netid']
	    } else {
		$fnetid = false
	    }
	    if ($nic['vid']) {
		$fvid = $nic['vid']
	    } else {
		$fvid = false
	    }
	    if ($nic['routes']) {
		$routes = $nic['routes']
	    } else {
		$routes = false
	    }
	    if ($network::vars::all_networks[$nicname]['igmp'] == true) {
		if (! defined(Class[Igmpproxy])) {
		     include igmpproxy
		}
	    }
	    if ($network::vars::all_networks[$nicname]['ftp'] == true) {
		if (! defined(Class[Ftpproxy])) {
		     include ftpproxy
		}
	    }
	    if ($network::vars::all_networks[$nicname]['tftp'] == true) {
		if (! defined(Class[Tftpproxy])) {
		     include tftpproxy
		}
	    }
	    if ($nic['rootif'] ) {
		network::interfaces::main {
		    $nicname:
			faddr    => $faddr,
			fmask    => $fmask,
			fnetid   => $fnetid,
			fvid     => $fvid,
			l2filter => $network::vars::all_networks[$nicname]['l2filter'],
			mtu      => $mtu,
			rootif   => $nic['rootif'],
			routes   => $routes;
		}
	    } elsif ($nic['ospfif']) {
		network::interfaces::main {
		    $nicname:
			faddr    => $faddr,
			fmask    => $fmask,
			fnetid   => $fnetid,
			fvid     => $fvid,
			l2filter => $network::vars::all_networks[$nicname]['l2filter'],
			mtu      => $mtu,
			ospfif   => $nic['ospfif'],
			routes   => $routes;
		}
	    }
	}
    }
}
