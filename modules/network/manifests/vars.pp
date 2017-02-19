class network::vars {
    $all_networks           = hiera_hash("vlan_database")
    $all_openvpns           = hiera_hash("openvpn_database")
    $bgp_database           = hiera("bgp_database")
    $dns_ip                 = hiera("dns_ip")
    $filtering_switches     = hiera("filtering_switches")
    $gre_tunnels            = hiera("gre_tunnels")
    $ipsec_tunnels          = hiera("ipsec_tunnels")
    $ovpn_networks          = hiera("active_openvpns")
    $switches_pass          = hiera("filtering_switches_passphrase")
    $switches_user          = hiera("filtering_switches_user")
    $main_networks          = hiera("net_ifs")
    $netmask_correspondance = hiera("netmask_correspondance")
    $tmp_netid              = hiera("office_netids")
    $tmp_networks           = hiera("active_vlans")
    $local_networks         = $tmp_networks[$domain]
    $office_netid           = $tmp_netid[$domain]
    $ospf_database          = hiera("ospf_database")
    $rip_map                = hiera("rip_map")
    $vpnserver_if           = hiera("vpnserver_if")
    $vpnserver_ip           = hiera("vpnserver_ip")

    if (hiera("ospf_redistribute")) {
	$has_ospf = true
    } else {
	$has_ospf = false
    }
}
