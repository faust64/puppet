class sasyncd::vars {
    $main_networks     = lookup("net_ifs")
    $sasyncd_group     = lookup("sasyncd_group")
    $sasyncd_interface = inline_template("<% @main_networks.each do |nic| -%><% if nic['pfsync'] == true -%><%=nic['name']%><% break -%><% end -%><% end -%>")
    $sasyncd_peer      = lookup("sasyncd_peer")
    $sasyncd_sharedkey = lookup("sasyncd_sharedkey")
}
