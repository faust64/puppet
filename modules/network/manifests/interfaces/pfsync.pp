define network::interfaces::pfsync($parent = false,
				   $peer   = false) {
    case $operatingsystem {
	"FreeBSD": {
	    network::interfaces::freebsd::pfsync {
		$name:
		    parent  => $parent,
		    peer    => $peer;
	    }
	}
	"OpenBSD": {
	    network::interfaces::openbsd::pfsync {
		$name:
		    parent  => $parent,
		    peer    => $peer;
	    }
	}
    }
}
