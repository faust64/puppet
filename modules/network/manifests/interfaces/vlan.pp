define network::interfaces::vlan($addr     = "127.0.0.1",
				 $ifstate  = false,
				 $l2filter = false,
				 $mtu      = false,
				 $nmask    = "255.0.0.0",
				 $root_if  = false,
				 $routes   = false,
				 $vid      = false,
				 $vvid     = false) {
    case $operatingsystem {
	"FreeBSD": {
	    network::interfaces::freebsd::vlan {
		$name:
		    addr     => $addr,
		    ifstate  => $ifstate,
		    mtu      => $mtu,
		    nmask    => $nmask,
		    root_if  => $root_if,
		    vid      => $vid;
	    }
	}
	"OpenBSD": {
	    network::interfaces::openbsd::vlan {
		$name:
		    addr     => $addr,
		    ifstate  => $ifstate,
		    l2filter => $l2filter,
		    mtu      => $mtu,
		    nmask    => $nmask,
		    root_if  => $root_if,
		    routes   => $routes,
		    vid      => $vid,
		    vvid     => $vvid;
	    }
	}
    }
}
