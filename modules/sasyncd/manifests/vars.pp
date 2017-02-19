class sasyncd::vars {
    $main_networks     = hiera("net_ifs")
    $sasyncd_group     = hiera("sasyncd_group")
    $sasyncd_interface = inline_template("<% @main_networks.each do |nic| -%><% if nic['carpaddr'] =~ /[0-9].[0-9]/ and nic['carpvhid'].to_i > 0 and (nic['vpn'] == true or nic['vpn'] =~ /[0-9].[0-9]/) -%>carp<%=nic['carpvhid']%><% break -%><% end -%><% end -%>")
    $sasyncd_peer      = hiera("sasyncd_peer")
    $sasyncd_sharedkey = hiera("sasyncd_sharedkey")
}
