class pf::public {
    $all_networks    = $pf::vars::all_networks
    $all_openvpns    = $pf::vars::all_openvpns
    $asterisk_ip     = $pf::vars::asterisk_ip
    $ipsec_tunnels   = $pf::vars::ipsec_tunnels
    $local_networks  = $pf::vars::local_networks
    $mail_ip         = $pf::vars::mail_ip
    $mail_mx         = $pf::vars::mail_mx
    $main_networks   = $pf::vars::main_networks
    $named_ip        = $pf::vars::named_ip
    $ovpn_networks   = $pf::vars::ovpn_networks
    $plex_ip         = $pf::vars::plex_ip
    $pubreverse_ip   = $pf::vars::pubreverse_ip
    $reverse_ip      = $pf::vars::reverse_ip
    $ssh_ip          = $pf::vars::ssh_ip
    $ssh_port        = $pf::vars::ssh_port
    $syslog_ip       = $pf::vars::syslog_ip
    $transmission_ip = $pf::vars::transmission_ip
    $visio_clients   = $pf::vars::visio_clients
    $visio_ip        = $pf::vars::visio_ip

    each($main_networks) |$nic| {
	if ($nic['gw']) {
	    $nicname = $nic['name']
	    if ($nic['carpaddr']) {
		$nicaddr = $nic['carpaddr']
	    }
	    else {
		$nicaddr = $nic['addr']
	    }
	    if ($nic['gatessh']) {
		$gatessh = $nic['gatessh']
	    }
	    else {
		$gatessh = false
	    }
	    if ($nic['reverse']) {
		$pubreverse = $nic['reverse']
	    }
	    else {
		$pubreverse = $nicaddr
	    }
	    if ($nic['pubreverse']) {
		$altreverse = $nic['pubreverse']
	    }
	    else {
		$altreverse = false
	    }
	    if ($nic['vpn']) {
		$pubvpn = $nic['vpn']
	    }
	    else {
		$pubvpn = $nicaddr
	    }
	    if ($nic['asterisk']) {
		$pubasterisk = $nic['asterisk']
	    }
	    else {
		$pubasterisk = false
	    }
	    if ($nic['mx']) {
		$pubmx = $nic['mx']
	    }
	    else {
		$pubmx = false
	    }
	    if ($nic['visio']) {
		$pubvisio = $nic['visio']
	    }
	    else {
		$pubvisio = false
	    }
	    $nicgw = $nic['gw']

	    if ($nic['carpvhid'] != undef and $nic['carpaddr'] != undef) {
		$vhid    = $nic['carpvhid']
		$alsonic = "carp$vhid"
	    }
	    else {
		$alsonic = false
	    }

	    if (! defined(File["Pf WAN $nicname configuration"])) {
		file {
		    "Pf WAN $nicname configuration":
			content => template("pf/public-rset.erb"),
			group   => lookup("gid_zero"),
			mode    => "0600",
			notify  => Exec["Reload pf configuration"],
			owner   => root,
			path    => "/etc/pf.d/WAN-$nicname",
			require => File["Pf Interfaces Configuration"];
		}
	    }
	}
    }
}
