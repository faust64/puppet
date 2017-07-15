class network::vars {
    $all_networks           = lookup("vlan_database", {merge => hash})
    $all_openvpns           = lookup("openvpn_database", {merge => hash})
    $bgp_database           = lookup("bgp_database")
    $dns_ip                 = lookup("dns_ip")
    $filtering_switches     = lookup("filtering_switches")
    $gre_tunnels            = lookup("gre_tunnels")
    $ipsec_tunnels          = lookup("ipsec_tunnels")
    $ovpn_networks          = lookup("active_openvpns")
    $switches_pass          = lookup("filtering_switches_passphrase")
    $switches_user          = lookup("filtering_switches_user")
    $main_networks          = lookup("net_ifs")
    $netmask_correspondance = lookup("netmask_correspondance")
    $tmp_netid              = lookup("office_netids")
    $tmp_networks           = lookup("active_vlans")
    $local_networks         = $tmp_networks[$domain]
    $office_netid           = $tmp_netid[$domain]
    $ospf_database          = lookup("ospf_database")
    $rip_map                = lookup("rip_map")
    $vpnserver_if           = lookup("vpnserver_if")
    $vpnserver_ip           = lookup("vpnserver_ip")

    if (lookup("ospf_redistribute")) {
	$has_ospf = true
    } else {
	$has_ospf = false
    }
}
