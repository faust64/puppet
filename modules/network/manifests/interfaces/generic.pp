define network::interfaces::generic($addr       = false,
				    $addr_alias = false,
				    $hwaddr     = false,
				    $ifstate    = "up",
				    $mtu        = false,
				    $nmask      = false,
				    $trunk      = "",
				    $routes     = false,
				    $ualias     = false) {
    case $operatingsystem {
	"FreeBSD": {
	    network::interfaces::freebsd::generic {
		$name:
		    addr       => $addr,
		    addr_alias => $addr_alias,
		    ifstate    => $ifstate,
		    mtu        => $mtu,
		    nmask      => $nmask;
	    }
	}
	"OpenBSD": {
	    network::interfaces::openbsd::generic {
		$name:
		    addr       => $addr,
		    addr_alias => $addr_alias,
		    hwaddr     => $hwaddr,
		    ifstate    => $ifstate,
		    mtu        => $mtu,
		    nmask      => $nmask,
		    trunk      => $trunk,
		    routes     => $routes,
		    ualias     => $ualias;
	    }
	}
    }
}
