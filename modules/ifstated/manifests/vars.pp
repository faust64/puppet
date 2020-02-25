class ifstated::vars {
    $alt_gateway    = lookup("ifstated_alt_gateway")
    $bypass         = lookup("ifstated_bypass")
    $carp_advbase   = lookup("carp_advbase")
    $conf_dir       = lookup("ifstated_conf_dir")
    $default_alerts = lookup("contact_alerts")
    $dhcp_ip        = lookup("dhcp_ip")
    $do_relay_dhcp  = lookup("ifstated_dhcrelay")
    $forcepuppetgw  = lookup("ifstated_force_puppet_gateway")
    $local_networks = lookup("active_vlans")
    $main_networks  = lookup("net_ifs")
    $munin_ip       = lookup("munin_ip")
    $pf_alerts      = lookup("contact_alerts_pf")
    $puppet_master  = lookup("puppetmaster")
    $sasyncd_peer   = lookup("sasyncd_peer")
    $ifstated_peer  = lookup("ifstated_peer")
    $vlan_database  = lookup("vlan_database")

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
