class openvpn::service {
    $local_openvpns      = $openvpn::vars::all_openvpns
    $office_netid        = $openvpn::vars::office_netid
    $openvpn_default_flt = $openvpn::vars::openvpn_default_filter
    $ovpn_networks       = $openvpn::vars::ovpn_networks[$domain]

    each($ovpn_networks) |$ovpn| {
	$ovpnname = $ovpn['name']

	if ($local_openvpns[$ovpnname]) {
	    if ($ovpn['netid']) {
		if ($ovpn['netid'] =~ /[0-9]\.[0-9]/) {
		    $tun_netid = $ovpn['netid']
		    $network   = "$tun_netid.0"
		} else {
		    $tun_netid = $ovpn['netid']
		    $network   = "10.$office_netid.$tun_netid.0"
		}
	    } else {
		if ($local_openvpns[$ovpnname]['netid'] =~ /[0-9]\.[0-9]/) {
		    $tun_netid = $local_openvpns[$ovpnname]['netid']
		    $network   = "$tun_netid.0"
		} else {
		    $tun_netid = $local_openvpns[$ovpnname]['netid']
		    $network   = "10.$office_netid.$tun_netid.0"
		}
	    }

	    if ($ovpn['netmsk']) {
		$netmsk = $ovpn['netmsk']
	    }
	    else {
		$netmsk = $local_openvpns[$ovpnname]['netmsk']
	    }

	    if ($ovpn['port']) {
		$port = $ovpn['port']
	    }
	    else {
		$port = $local_openvpns[$ovpnname]['port']
	    }

	    if ($ovpn['server']) {
		$is_server = true
	    } elsif ($local_openvpns[$ovpnname]['server']) {
		$is_server = true
	    } else {
		$is_server = false
	    }

	    if ($is_server and $local_openvpns[$ovpnname]['filter']) {
		$conn_filter = $local_openvpns[$ovpnname]['filter']
	    }
	    else {
		$conn_filter = $openvpn_default_flt
	    }

	    if ($is_server and $ovpn['rootif']) {
		openvpn::define::server {
		    $ovpnname:
			bridge  => false,
			filter  => $conn_filter,
			iface   => $ovpn['rootif'],
			netmsk  => $netmsk,
			network => $network,
			port    => $port;
		}
	    }
	}
    }

    exec {
	"Reload OpenVPN services":
	    command     => "openvpn_resync -r",
	    cwd         => "/",
	    path        => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
	    refreshonly => true,
	    require     => File["OpenVPN application script"];
    }

    if ($kernel == "Linux") {
	exec {
	    "Reload iptables configuration":
		command     => "/etc/firewall/apply",
		cwd         => "/",
		path        => "/usr/sbin:/sbin:/usr/bin:/bin",
		refreshonly => true;
	}
    }
}
