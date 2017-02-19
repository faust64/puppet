class ifstated::vars {
    $alt_gateway    = hiera("ifstated_alt_gateway")
    $bypass         = hiera("ifstated_bypass")
    $carp_advbase   = hiera("carp_advbase")
    $conf_dir       = hiera("ifstated_conf_dir")
    $default_alerts = hiera("contact_alerts")
    $dhcp_ip        = hiera("dhcp_ip")
    $do_relay_dhcp  = hiera("ifstated_dhcrelay")
    $local_networks = hiera("active_vlans")
    $main_networks  = hiera("net_ifs")
    $munin_ip       = hiera("munin_ip")
    $pf_alerts      = hiera("contact_alerts_pf")
    $sasyncd_peer   = hiera("sasyncd_peer")
    $ifstated_peer  = hiera("ifstated_peer")
    $vlan_database  = hiera("vlan_database")

    if (defined(Class[Ftpproxy])) {
	$has_ftpproxy = true
    } else {
	$has_ftpproxy = false
    }
    if (defined(Class[Tftpproxy]) and $kernelrelease =~ /5\.[3-9]/) {
	$has_tftpproxy = true
    } else {
	$has_tftpproxy = false
    }
    if (defined(Class[Relayd])) {
	$has_relayd = true
    } else {
	$has_relayd = false
    }
    if (defined(Class[Pf])) {
	$has_pf = true
    } else {
	$has_pf = false
    }
    if (defined(Class[Ipsecctl])) {
	$has_ipsecctl = true
    } else {
	$has_ipsecctl = false
    }
    if (defined(Class[Ospfd])) {
	$has_ospfd = true
    } else {
	$has_ospfd = false
    }
    if (defined(Class[Openvpn])) {
	$has_openvpn = true
    } else {
	$has_openvpn = false
    }
    if (defined(Class[Unbound])) {
	$has_unbound = true
    } else {
	$has_unbound = false
    }

    if ($pf_alerts) {
	$contact_alerts = $pf_alerts
    } else {
	$contact_alerts = $default_alerts
    }
    if ($ifstated_peer) {
	$sync_peer = $ifstated_peer
    } else {
	$sync_peer = $sasyncd_peer
    }
}
