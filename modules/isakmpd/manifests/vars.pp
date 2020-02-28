class isakmpd::vars {
    $conf_dir             = lookup("isakmpd_conf_dir")
    $ipsec_tunnels        = lookup("ipsec_tunnels")
    $isakmpd_dpd_interval = lookup("isakmpd_dpd_interval")
    $isakmpd_lifetimep1   = lookup("isakmpd_lifetimep1")
    $isakmpd_lifetimep2   = lookup("isakmpd_lifetimep2")
    $main_networks        = lookup("net_ifs")
    if (lookup("isakmpd_listen") != false) {
	$isakmpd_listen   = hiera("isakmpd_listen")
    } else {
	$isakmpd_list     = inline_template("<% if @ipsec_tunnels -%><% @ipsec_tunnels.each do |tunname, tunhash| -%><% if tunhash['localgw'] =~ /[0-9].[0-9]/ -%><%=tunhash['localgw']%>,<% end -%><% end -%><% end -%>")
	$isakmpd_listen   = $isakmpd_list.split(',')
    }

    if (lookup("jumeau") != false) {
	$args = '-K -S -v'
    } else {
	$args = '-K -v'
    }
}
