define network::interfaces::freebsd::generic($addr       = false,
					     $addr_alias = false,
					     $ifstate    = "up",
					     $mtu        = false,
					     $nmask      = false) {
    if ($mtu) {
	if ($addr and $nmask) {
	    $args = "inet $addr netmask $nmask mtu $mtu"
	}
	else {
	    $args = "$ifstate mtu $mtu"
	}
    else {
	if ($addr and $nmask) {
	    $args = "inet $addr netmask $nmask"
	}
	else {
	    $args = $ifstate
	}
    }

    common::define::lined {
	"Configure $name interface":
	    line => "ifconfig_$name='$args'",
	    path => "/etc/rc.conf",
    }

#    if ($addr_alias and $nmask) {
#	each($addr_alias) |$addr| {
#	    exec {
#	    }
#	}
#    }
}
