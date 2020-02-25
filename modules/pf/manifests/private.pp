class pf::private {
    each($pf::vars::local_networks[$domain]) |$nic| {
	if ($nic['rootif'] or $nic['ospfif'] ) {
	    $nicname = $nic['name']
	    $vlanname = $pf::vars::all_networks[$nicname]['name']
	    if ($nic['rootif'] ) {
		$root_if = $nicname
		if ($pf::vars::all_networks[$nicname]['l2filter'] ) {
		    $l2filter = sprintf(" tagged %s_trusted", $nicname)
		}
		else {
		    $l2filter = ""
		}
	    }
	    else {
		$root_if  = $nic['ospfif']
		$l2filter = ""
	    }

	    if ($pf::vars::vpnserver_ip != '127.0.0.1') {
		$routeto     = ''
		$routetopriv = ''
	    }
	    else {
		$routeto     = ' route-to ( $def_if $def_gw )'
		$routetopriv = ' route-to ( $wan_if $wan_gw )'
	    }

	    pf::define::vlan {
		$nicname:
		    l2filter    => $l2filter,
		    root_if     => $root_if,
		    routeto     => $routeto,
		    routetopriv => $routetopriv,
		    vlanname    => $vlanname;
	    }
	}
    }
}
