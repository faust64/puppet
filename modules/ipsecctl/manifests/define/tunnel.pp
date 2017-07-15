define ipsecctl::define::tunnel($dhgroup       = $ipsecctl::vars::ipsec_defaults['groupp1'],
				$encp1         = $ipsecctl::vars::ipsec_defaults['authp1'],
				$encp2         = $ipsecctl::vars::ipsec_defaults['authp2'],
				$hashp1        = $ipsecctl::vars::ipsec_defaults['hashp1'],
				$hashp2        = $ipsecctl::vars::ipsec_defaults['hashp2'],
				$localdomain   = false,
				$localgateway  = false,
				$passphrase    = $ipsecctl::vars::ipsec_defaults['passphrase'],
				$pfsgroup      = $ipsecctl::vars::ipsec_defaults['groupp2'],
				$icmpproof     = false,
				$remotedomain  = false,
				$remotegateway = false,
				$tagged        = false) {
    file {
	"IPSEC tunnel to $name":
	    content => template("ipsecctl/tunnel.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0640",
	    notify  => Exec["Reload ipsec configuration"],
	    owner   => root,
	    path    => "/etc/ipsec.d/$name",
	    require => File["Prepare Ipsecctl for further configuration"];
    }

    File["IPSEC tunnel to $name"]
	-> File["Install Ipsecctl main configuration"]

    ipsecctl::define::nagiostun {
	$name:
    }
}
