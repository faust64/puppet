class isakmpd::vars {
    $conf_dir             = hiera("isakmpd_conf_dir")
    $ipsec_tunnels        = hiera("ipsec_tunnels")
    $isakmpd_dpd_interval = hiera("isakmpd_dpd_interval")
    $isakmpd_lifetimep1   = hiera("isakmpd_lifetimep1")
    $isakmpd_lifetimep2   = hiera("isakmpd_lifetimep2")
    $main_networks        = hiera("net_ifs")
    $isakmpd_list         = inline_template("<% if @ipsec_tunnels -%><% @ipsec_tunnels.each do |tunname, tunhash| -%><% if tunhash['localgw'] =~ /[0-9].[0-9]/ -%><%=tunhash['localgw']%>,<% end -%><% end -%><% end -%>")
    $isakmpd_listen       = $isakmpd_list.split(',')

    if (hiera("jumeau") != false) {
	$args = '-K -S -v'
    } else {
	$args = '-K -v'
    }
}
