define ipsecctl::define::gretunnel($dhgroup       = $ipsecctl::vars::ipsec_defaults['groupp1'],
				   $encp1         = $ipsecctl::vars::ipsec_defaults['authp1'],
				   $encp2         = $ipsecctl::vars::ipsec_defaults['authp2'],
				   $hashp1        = $ipsecctl::vars::ipsec_defaults['hashp1'],
				   $hashp2        = $ipsecctl::vars::ipsec_defaults['hashp2'],
				   $localaddr     = false,
				   $gateway       = false,
				   $linktype      = "sdsl-sdsl",
				   $passphrase    = $ipsecctl::vars::ipsec_defaults['passphrase'],
				   $pfsgroup      = $ipsecctl::vars::ipsec_defaults['groupp2'],
				   $remote        = false,
				   $tagged        = false) {
    $loc_office_id = $ipsecctl::vars::netids[$domain]
    $rem_office_id = $ipsecctl::vars::netids[$remote]

    if ($loc_office_id < $rem_office_id) {
	case $linktype {
	    "sdsl-sdsl":	{ $linkval = 1 }
	    "sdsl-adsl":	{ $linkval = 2 }
	    "sdsl-sip":		{ $linkval = 3 }
	    "adsl-sdsl":	{ $linkval = 4 }
	    "adsl-adsl":	{ $linkval = 5 }
	    "adsl-sip":		{ $linkval = 6 }
	    "sip-sdsl":		{ $linkval = 7 }
	    "sip-adsl":		{ $linkval = 8 }
	    "sip-sip":		{ $linkval = 9 }
	}
	$outloc = $loc_office_id + $linkval
	$outrem = $rem_office_id + $linkval + 64
    } else {
	case $linktype {
	    "sdsl-sdsl":	{ $linkval = 1 }
	    "adsl-sdsl":	{ $linkval = 2 }
	    "sip-sdsl":		{ $linkval = 3 }
	    "sdsl-adsl":	{ $linkval = 4 }
	    "adsl-adsl":	{ $linkval = 5 }
	    "sip-adsl":		{ $linkval = 6 }
	    "sdsl-sip":		{ $linkval = 7 }
	    "adsl-sip":		{ $linkval = 8 }
	    "sip-sip":		{ $linkval = 9 }
	}
	$outloc = $loc_office_id + $linkval + 64
	$outrem = $rem_office_id + $linkval
    }
    $office = $loc_office_id + $rem_office_id

    $leftdomain  = "10.255.$office.$outloc"
    $rightdomain = "10.255.$office.$outrem"

    ipsecctl::define::tunnel {
	$name:
	    dhgroup       => $dhgroup,
	    encp1         => $encp1,
	    encp2         => $encp2,
	    hashp1        => $hashp1,
	    hashp2        => $hashp2,
	    localdomain   => $leftdomain,
	    localgateway  => $localaddr,
	    pfsgroup      => $pfsgroup,
	    remotedomain  => $rightdomain,
	    remotegateway => $gateway,
	    tagged        => $tagged;
    }
}
