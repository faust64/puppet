define network::interfaces::freebsd::vlan($addr     = "127.0.0.1",
					  $ifstate  = false,
					  $mtu      = false,
					  $nmask    = "255.0.0.0",
					  $root_if  = false,
					  $vid      = 1) {
    if ($addr) {
	$args = "inet $addr netmask $nmask vhid $vid vlandev $root_if"
    } elsif ($ifstate) {
	$args = "$ifstate vhid $vid vlandev $root_if"
    } else {
	$args = false
    }
    if ($mtu != false) {
	$argsmtu = " mtu $mtu"
    } else {
	$argsmtu = ""
    }

    if ($args) {
	common::define::lined {
	    "Configure $name interface":
		line => "ifconfig_$name='$args$argsmtu'",
		path => "/etc/rc.conf";
	}
    } else {
	notify {
	    "sortoffail [$name]":
		message => "Unsupported combination with no address nor ifstate";
	}
    }
}
