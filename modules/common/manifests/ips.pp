class common::ips {
    each (split($interfaces, ',')) |$nic| {
	if ($nic =~ /eth/ or $nic =~ /venet/ or $nic =~ /vnet/ or $nic =~ /em/
	    or $nic =~ /bge/ or $nic =~ /vlan/ or $nic =~ /fxp/ or $nic =~ /xe/
	    or $nic =~ /carp/ or $nic =~ /rl/ or $nic =~ /re/ or $nic =~ /lagg/
	    or $nic =~ /bond[0-9]*$/ or $nic =~ /br/ or $nic =~ /p[0-9]p/
	    or $nic =~ /trunk/) {
	    $ipaddr = inline_template("<%=@ipaddress_${nic}%>")
	    $hwaddr = inline_template("<%=@macaddress_${nic}%>")

	    if ($ipaddr =~ /[0-9]\.[0-9]/) {
		common::define::static_lease {
		    "$fqdn $nic":
			hname  => "$hostname-$nic",
			hwaddr => $hwaddr,
			ipaddr => $ipaddr;
		}
	    }
	}
    }
}
