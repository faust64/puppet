class ipsecctl::sasyncd {
    each($ipsecctl::vars::main_networks) |$nic| {
	if ($nic['carpaddr'] != undef
	    and $nic['carpvhid'] != undef
	    and $nic['vpn'] != undef) {
	    each($ipsecctl::vars::main_networks) |$nac| {
		if ($nac['pfsync'] == true) {
		    include ::sasyncd
		}
	    }
	}
    }
}
