class iscdhcpserver::vars {
    $ad_ip                  = hiera("ad_ip")
    $all_networks           = hiera("vlan_database")
    $collect                = hiera("dhcpd_collect_static_leases")
    $dhcp_conf_dir          = hiera("dhcpd_conf_dir")
    $dhcp_ip                = hiera("dhcp_ip")
    $dns_ip                 = hiera("dns_ip")
    $local_networks         = hiera("active_vlans")
    $netmask_correspondance = hiera("netmask_correspondance")
    $office_netids          = hiera("office_netids")
    $pxe_ip                 = hiera("pxe_ip")
    $rndc_key               = hiera("named_rndc_key")
    $root_domain            = hiera("root_domain")
    $search                 = hiera("dns_search")
    $service_name           = hiera("dhcp_isc_service_name")

    if ($root_domain != false) {
	$mydomain = $root_domain
    } else {
	$mydomain = $domain
    }
}
