class pf::openvpn {
    $all_networks     = $pf::vars::all_networks
    $all_openvpns     = $pf::vars::all_openvpns
    $local_networks   = $pf::vars::local_networks
    $openvpn_conf_dir = $pf::vars::openvpn_conf_dir
    $ovpn_networks    = $pf::vars::ovpn_networks
    $ovpn_pushd       = $pf::vars::openvpn_pushd_networks

    if ($pf::vars::vpnserver_ip == "127.0.0.1") {
	include ::openvpn
    }
    else {
	cron {
	    "Reload OpenVPN instances":
		ensure => absent,
		user   => root;
	}

	file {
	    $openvpn_conf_dir:
		ensure  => absent,
		force   => true,
		recurse => true;
	}
    }

    each($ovpn_networks[$domain]) |$nic| {
	if ($nic['rootif']) {
	    $nicname = $nic['name']
	    if ($all_openvpns[$nicname]['server'] == true or ($nic['server'] == true)) {
		if ($pf::vars::vpnserver_ip == "127.0.0.1") {
		    $root_if = $nic['rootif']
		}
		else {
		    $root_if = $pf::vars::vpnserver_if
		}
		if ($all_openvpns[$nicname]['mapto']) {
		    $nicmap = $all_openvpns[$nicname]['mapto']
		    if ($all_networks[$nicmap]['acl']) {
			$aclmap = $all_networks[$nicmap]['acl']
		    }
		    else {
			$aclmap = false
		    }
		}
		else {
		    $aclmap = false
		}

		if (! defined(File["Pf OpenVPN $nicname configuration"])) {
		    file {
			"Pf OpenVPN $nicname configuration":
			    content => template("pf/ovpn-rset.erb"),
			    group   => hiera("gid_zero"),
			    mode    => "0600",
			    notify  => Exec["Reload pf configuration"],
			    owner   => root,
			    path    => "/etc/pf.d/OpenVPN-$nicname",
			    require => File["Pf Configuration directory"];
		    }
		}
	    }
	}
    }
}
