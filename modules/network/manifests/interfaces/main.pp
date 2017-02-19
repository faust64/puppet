define network::interfaces::main($faddr    = false,
				 $fmask    = false,
				 $fmtu     = false,
				 $fnetid   = false,
				 $fvid     = false,
				 $l2filter = false,
				 $ospfif   = false,
				 $rootif   = false,
				 $routes   = false) {
    $all_networks = $network::vars::all_networks
    $netmask_crsp = $network::vars::netmask_correspondance

    if ($fvid) {
	$vid = $fvid
    } else {
	$vid = $all_networks[$name]['vid']
    }
    $vvid = $all_networks[$name]['vid']
    if ($l2filter and $network::vars::filtering_switches) {
	network::interfaces::hwfilter {
	    $name:
	}
    }
    if ($rootif) {
	if ($all_networks[$name]) {
	    if ($fnetid) {
		$vlan_net_id = $fnetid
	    } elsif ($all_networks[$name]["netid"]) {
		$vlan_net_id = $all_networks[$name]["netid"]
	    } else {
		err { "No network ID for $name": }
	    }
	    if ($vlan_net_id =~ /[0-9]\.[0-9]/) {
		$network = regsubst($vlan_net_id,
				    '^(\d+)\.(\d+)\.(\d+).*$',
				    '\1.\2.\3.0')
	    } else {
		$office_netid = $network::vars::office_netid
		$network      = "10.$office_netid.$vlan_net_id.0"
	    }
	    if ($fmask) {
		$shortmask = $fmask
	    } elsif ($all_networks[$name]["netmsk"]) {
		$shortmask = $all_networks[$name]["netmsk"]
	    } else {
		$shortmask = 24
	    }
	    $hostid    = hiera("hostid")
	    $carp_addr = regsubst($network, '^(\d+)\.(\d+)\.(\d+)\.(\d+)$',
				  '\1.\2.\3.1')
	    if ($shortmask > 0) {
		$b1 = regsubst($network, '^(\d+)\.(\d+)\.(\d+)\.(\d+)$', '\1')
		$b2 = regsubst($network, '^(\d+)\.(\d+)\.(\d+)\.(\d+)$', '\2')
		$b3 = regsubst($network, '^(\d+)\.(\d+)\.(\d+)\.(\d+)$', '\3')
		$b4 = regsubst($network, '^(\d+)\.(\d+)\.(\d+)\.(\d+)$', '\4')

		$increment = $shortmask % 8
		case $increment {
		    7:	{ $finc = 1 }
		    6:	{ $finc = 3 }
		    5:	{ $finc = 7 }
		    4:	{ $finc = 15 }
		    3:	{ $finc = 31 }
		    2:	{ $finc = 63 }
		    1:	{ $finc = 127 }
		    0:	{ $finc = 255 }
		}

		if ($shortmask < 8) {
		    $w1 = $b1 + $finc
		    $w2 = "255"
		    $w3 = "255"
		    $w4 = "255"
		} elsif ($shortmask < 16) {
		    $w1 = $b1
		    $w2 = $b2 + $finc
		    $w3 = "255"
		    $w4 = "255"
		} elsif ($shortmask < 24) {
		    $w1 = $b1
		    $w2 = $b2
		    $w3 = $b3 + $finc
		    $w4 = "255"
		} elsif ($b4 =~ /[0-9]\.[0-9]/) {
#FIXME: obvious
		    $lolcast = "$b4.$finc"
		} else {
		    $w1 = $b1
		    $w2 = $b2
		    $w3 = $b3
		    $w4 = $b4 + $finc
		}

		if (! $lolcast) {
		    $lolcast = "$w1.$w2.$w3.$w4"
		}
	    }
	    if ($faddr == false) {
		$tmpaddr = regsubst($network, '^(\d+)\.(\d+)\.(\d+)\.(\d+)$',
				  '\1.\2.\3')
		$myaddr  = "$tmpaddr.$hostid"
	    } else {
		$myaddr = $faddr
	    }
	    $nmask = $netmask_crsp[$shortmask]
# FU, whales
#	    if ($network::vars::vpnserver_if == $name
#		and $network::vars::vpnserver_ip != "127.0.0.1") {
#		$all_openvpns  = $network::vars::all_openvpns
#		$ovpn_networks = $network::vars::ovpn_networks
#		$vpnserver_ip  = $network::vars::vpnserver_ip
#		$routelist     = inline_template("[ <% @ovpn_networks.each do |net| -%><% vpnname = net['name'] -%><% if @all_openvpns[vpnname]['server'] == true or net['server'] == true -%>[ net: <% if net['netid'] =~ /[0-9]\.[0-9]/ -%><%=net['netid']%><% elsif @all_openvpns[vpnname]['netid'] =~ /[0-9]\.[0-9]/ -%><%=@all_openvpns[vpnname]['netid']%><% else -%>10.<%=@office_netid%>.<% if net['netid'] =~ /[0-9]/ -%><%=net['netid']%><% else -%><%=@all_openvpns[vpnname]['netid']%><% end -%><% end -%>.0/<% if net['netmsk'] =~ /[0-9]/ -%><%=net['netmsk']%><% else -%><%=@all_openvpns[vpnname]['netmsk']%><% end -%>, gw: <%=@vpnserver_ip%> ],<% end -%><% end -%> ]")
##FIXME: merge with $routes
#		$myroutes      = $routelist
#	    } else {
		$myroutes = $routes
# FU, dolphins
#	    }

	    if ($vid > 0)
	    {
		if ($hostid != 1) {
		    network::interfaces::vlan {
			$name:
			    addr     => $myaddr,
			    l2filter => $l2filter,
			    nmask    => $nmask,
			    root_if  => $rootif,
			    vid      => $vid,
			    vvid     => $vvid;
		    }

		    network::interfaces::carp {
			$name:
			    addr    => $carp_addr,
			    bcast   => $lolcast,
			    nmask   => $nmask,
			    root_if => "vlan$vvid",
			    routes  => $myroutes,
			    vhid    => $vvid;
		    }
		} else {
		    network::interfaces::vlan {
			$name:
			    addr     => $myaddr,
			    l2filter => $l2filter,
			    nmask    => $nmask,
			    root_if  => $rootif,
			    routes   => $myroutes,
			    vid      => $vid,
			    vvid     => $vvid;
		    }
		}
	    } else {
		network::interfaces::generic {
		    $name:
			addr    => $myaddr,
			mtu     => $fmtu,
			nmask   => $nmask,
			root_if => $rootif,
			routes  => $myroutes;
		}
	    }
	}
    }
}
