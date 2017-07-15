class dhcrelay::vars {
    $all_networks   = lookup("active_vlans")
    $dhcp_ip        = lookup("dhcp_ip")
    $do_relay_dhcp  = lookup("ifstated_dhcrelay")
    $local_networks = $all_networks[$domain]
    $vlan_database  = lookup("vlan_database")

    if ($do_relay_dhcp and $dhcp_ip) {
#can not use multiple `-i' in openbsd. works with freebsd though, ...
	$obsd_ifs   = inline_template("<% @local_networks.each do |vlan| -%><% vlanname = vlan['name'] -%><% if vlan['rootif'] =~ /[a-z][0-9]/ and @vlan_database[vlanname]['dhcp'] == true -%> -i <%=vlanname%><% end -%><% end -%>")
	$targets    = inline_template("<% @dhcp_ip.each do |backend| -%> <%=backend%><% end -%>")
    }
    else {
	$obsd_ifs   = false
	$targets    = false
    }
}
