class ipsecctl::tunnels {
    $ipsec_defaults = $ipsecctl::vars::ipsec_defaults
    $main_networks  = $ipsecctl::vars::main_networks

    if ($ipsecctl::vars::ipsec_tunnels) {
	each($ipsecctl::vars::ipsec_tunnels) |$tun, $tunhash| {
	    if ($tunhash['localnet'] ) {
		$locnet = $tunhash['localnet']
	    } else {
		$netid  = $ipsecctl::vars::netids[$domain]
		$locnet = "10.$netid.0.0/16"
	    }
	    if ($tunhash['localgw'] ) {
		$locgw = $tunhash['localgw']
	    } elsif ($main_networks) {
		each($main_networks) |$nic| {
		    if ($nic['gw'] and $nic['vpn'] =~ /[0-9]\.[0-9]/) {
			$locgw = $nic['vpn']
		    }
		}
	    }
	    if ($tunhash['authp1'] != undef) {
		$encp1 = $tunhash['authp1']
	    } else {
		$encp1 = $ipsec_defaults['authp1']
	    }
	    if ($tunhash['hashp1'] != undef) {
		$hashp1 = $tunhash['hashp1']
	    } else {
		$hashp1 = $ipsec_defaults['hashp1']
	    }
	    if ($tunhash['authp2'] != undef) {
		$encp2 = $tunhash['authp2']
	    } else {
		$encp2 = $ipsec_defaults['authp2']
	    }
	    if ($tunhash['hashp1'] != undef) {
		$hashp2 = $tunhash['hashp2']
	    } else {
		$hashp2 = $ipsec_defaults['hashp2']
	    }
	    if ($tunhash['groupp1'] != undef) {
		$dhgroup = $tunhash['groupp1']
	    } else {
		$dhgroup = $ipsec_defaults['groupp1']
	    }
	    if ($tunhash['groupp2'] != undef) {
		$pfs = $tunhash['groupp2']
	    } else {
		$pfs = $ipsec_defaults['groupp2']
	    }
	    if ($tunhash['icmpproof'] == undef) {
		$icmpproof = false
	    } else {
		$icmpproof = $tunhash['icmpproof']
	    }
	    if ($tunhash['passphrase'] != undef) {
		$thepassphrase = $tunhash['passphrase']
	    } else {
		$thepassphrase = $ipsecctl::vars::ipsec_defaults['passphrase']
	    }
	    if ($tunhash['remotenet'] != undef and $tunhash['remotegw'] != undef and $locgw != undef and $thepassphrase != undef) {
		ipsecctl::define::tunnel {
		    $tun:
			dhgroup       => $dhgroup,
			encp1         => $encp1,
			encp2         => $encp2,
			hashp1        => $hashp1,
			hashp2        => $hashp2,
			icmpproof     => $icmpproof,
			localdomain   => $locnet,
			localgateway  => $locgw,
			passphrase    => $thepassphrase,
			pfsgroup      => $pfs,
			remotedomain  => $tunhash['remotenet'],
			remotegateway => $tunhash['remotegw'];
		}
	    }
	}
    }
}
