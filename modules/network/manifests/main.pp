class network::main {
    $ipsec_offices = $network::vars::ipsec_offices
    $netids        = $network::vars::tmp_netid

    each($network::vars::main_networks) |$nic| {
	if ($nic['name'] =~ /wlan/) {
	    include wpasupplicant
	}
	if ($nic['mtu']) {
	    $mtu = $nic['mtu']
	} else {
	    $mtu = $network::vars::default_mtu
	}
	if ($nic['hwaddr']) {
	    $hwaddr = $nic['hwaddr']
	} else {
	    $hwaddr = false
	}
	if ($nic['routes']) {
	    $routes = $nic['routes']
	} else {
	    $routes = false
	}
	if ($nic['trunkproto'] ) {
	    if ($nic['trunkopts'] ) {
		$trunk1 = $nic['trunkproto']
		$trunk2 = $nic['trunkopts']
		$trunk = "$trunk1 $trunk2"
	    } else {
		$trunk = $nic['trunkproto']
	    }
	} else {
	    $trunk = ""
	}
	if ($nic['vid'] != undef and $nic['rootif'] != undef) {
	    $rootif = $nic['rootif']
	    $vid    = $nic['vid']
	} else {
	    $rootif = false
	    $vid    = false
	}
	if ($nic['gatessh'] or $nic['asterisk'] or $nic['mx'] or $nic['reverse']
	    or $nic['pubreverse'] or $nic['vpn'] or $nic['visio']) {
	    if ($nic['gatessh'] != undef) {
		$alias1 = $nic['gatessh']
	    } else {
		$alias1 = false
	    }
	    if ($nic['asterisk'] != undef) {
		if ($nic['asterisk'] != $alias1) {
		    $alias2 = $nic['asterisk']
		} else {
		    $alias2 = false
		}
	    } else {
		$alias2 = false
	    }
	    if ($nic['mx'] != undef) {
		if ($nic['mx'] != $alias1
		    and $nic['mx'] != $alias2) {
		    $alias3 = $nic['mx']
		} else {
		    $alias3 = false
		}
	    } else {
		$alias3 = false
	    }
	    if ($nic['reverse'] != undef) {
		if ($nic['reverse'] != $alias1
		    and $nic['reverse'] != $alias2
		    and $nic['reverse'] != $alias3) {
		    $alias4 = $nic['reverse']
		} else {
		    $alias4 = false
		}
	    } else {
		$alias4 = false
	    }
	    if ($nic['vpn'] != undef) {
		if ($nic['vpn'] != $alias1
		    and $nic['vpn'] != $alias2
		    and $nic['vpn'] != $alias3
		    and $nic['vpn'] != $alias4) {
		    $alias5 = $nic['vpn']
		} else {
		    $alias5 = false
		}
	    } else {
		$alias5 = false
	    }
	    if ($nic['visio'] != undef) {
		if ($nic['visio'] != $alias1
		    and $nic['visio'] != $alias2
		    and $nic['visio'] != $alias3
		    and $nic['visio'] != $alias4
		    and $nic['visio'] != $alias5) {
		    $alias6 = $nic['visio']
		} else {
		    $alias6 = false
		}
	    } else {
		$alias6 = false
	    }
	    if ($nic['pubreverse'] != undef) {
		if ($nic['pubreverse'] != $alias1
		    and $nic['pubreverse'] != $alias2
		    and $nic['pubreverse'] != $alias3
		    and $nic['pubreverse'] != $alias4
		    and $nic['pubreverse'] != $alias5
		    and $nic['pubreverse'] != $alias6) {
		    $alias7 = $nic['pubreverse']
		} else {
		    $alias7 = false
		}
	    } else {
		$alias7 = false
	    }
	    $addr_alias = [ $alias1, $alias2, $alias3, $alias4,
			    $alias5, $alias6, $alias7 ]
	} else {
	    $addr_alias = false
	}
	if ($nic['unrelated_alias']) {
	    $ualias = $nic['unrelated_alias']
	} else {
	    $ualias = false
	}
	if ($nic['fuckingdhcp']) {
	    include network::dhclient
	    $ifstate = "dhcp"
	} else {
	    $ifstate = "up"
	}

	if ($nic['addr'] and $nic['netmsk'] ) {
	    if ($vid and $rootif) {
		network::interfaces::vlan {
		    $nic['name']:
			addr    => $nic['addr'],
			mtu     => $mtu,
			nmask   => $nic['netmsk'],
			root_if => $rootif,
			vid     => $vid,
			vvid    => $vid;
		}
	    } elsif ($nic['carpaddr'] and $nic['carpvhid'] and $nic['bcast']) {
		network::interfaces::generic {
		    $nic['name']:
			addr       => $nic['addr'],
			hwaddr     => $hwaddr,
			ifstate    => $ifstate,
			mtu        => $mtu,
			nmask      => $nic['netmsk'],
			trunk      => $trunk;
		}
	    } else {
		network::interfaces::generic {
		    $nic['name']:
			addr       => $nic['addr'],
			addr_alias => $addr_alias,
			hwaddr     => $hwaddr,
			ifstate    => $ifstate,
			mtu        => $mtu,
			nmask      => $nic['netmsk'],
			routes     => $routes,
			trunk      => $trunk,
			ualias     => $ualias;
		}
	    }
	} elsif ($vid and $rootif) {
	    network::interfaces::vlan {
		$nic['name']:
		    addr    => false,
		    ifstate => $ifstate,
		    mtu     => $mtu,
		    root_if => $rootif,
		    vid     => $vid,
		    vvid    => $vid;
	    }
	} elsif (! defined(Network::Interfaces::Generic[$nic['name']])) {
	    network::interfaces::generic {
		$nic['name']:
		    hwaddr  => $hwaddr,
		    ifstate => $ifstate,
		    mtu     => $mtu,
		    routes  => $routes,
		    trunk   => $trunk;
	    }
	}
	if ($nic['carpaddr'] and $nic['carpvhid'] and $nic['bcast']) {
	    $vhid = $nic['carpvhid']
	    network::interfaces::carp {
		"carp$vhid":
		    vhid       => $vhid,
		    addr       => $nic['carpaddr'],
		    addr_alias => $addr_alias,
		    bcast      => $nic['bcast'],
		    mtu        => $mtu,
		    nmask      => $nic['netmsk'],
		    root_if    => $nic['name'],
		    routes     => $routes,
		    ualias     => $ualias;
	    }
	}
	if ($nic['pfsync'] == true) {
	    network::interfaces::pfsync {
		$nic['name']:
		    parent => $nic['name'];
	    }
	}
	if ($rootif) {
	    if (! defined(Network::Interfaces::Generic[$rootif])) {
		network::interfaces::generic {
		    $rootif:
		}
	    }
	}
	if ($nic['gw'] and $nic['default'] == true) {
	    if (! defined(Network::Interfaces::Gateway["Default"])) {
		network::interfaces::gateway {
		    "Default":
			gw => $nic['gw'];
		}
	    }
	}
    }
}
