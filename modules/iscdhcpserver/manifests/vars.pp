class iscdhcpserver::vars {
    $ad_ip                  = lookup("ad_ip")
    $all_networks           = lookup("vlan_database")
    $collect                = lookup("dhcpd_collect_static_leases")
    $dhcp_conf_dir          = lookup("dhcpd_conf_dir")
    $dhcp_ip                = lookup("dhcp_ip")
    $dns_ip                 = lookup("dns_ip")
    $local_networks         = lookup("active_vlans")
    $netmask_correspondance = lookup("netmask_correspondance")
    $office_netids          = lookup("office_netids")
    $pxe_ip                 = lookup("pxe_ip")
    $rndc_key               = lookup("named_rndc_key")
    $root_domain            = lookup("root_domain")
    $search                 = lookup("dns_search")
    $service_name           = lookup("dhcp_isc_service_name")

    if ($root_domain != false) {
	$mydomain = $root_domain
    } else {
	$mydomain = $domain
    }
}
