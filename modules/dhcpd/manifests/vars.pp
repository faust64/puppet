class dhcpd::vars {
    $all_networks           = lookup("vlan_database", {merge => hash})
    $dns_ip                 = lookup("dns_ip")
    $conf_dir               = lookup("dhcpd_conf_dir")
    $local_networks         = lookup("active_vlans")
    $netmask_correspondance = lookup("netmask_correspondance")
    $netids                 = lookup("office_netids")
    $pxe_ip                 = lookup("pxe_ip")
}
