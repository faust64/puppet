class dhcpd::vars {
    $all_networks           = hiera_hash("vlan_database")
    $dns_ip                 = hiera("dns_ip")
    $conf_dir               = hiera("dhcpd_conf_dir")
    $local_networks         = hiera("active_vlans")
    $netmask_correspondance = hiera("netmask_correspondance")
    $netids                 = hiera("office_netids")
    $pxe_ip                 = hiera("pxe_ip")
}
