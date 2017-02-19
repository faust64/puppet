define network::interfaces::gateway($gw = false) {
    case $operatingsystem {
	"FreeBSD": {
	    network::interfaces::freebsd::gateway {
		$name:
		    gw => $gw;
	    }
	}
	"OpenBSD": {
	    network::interfaces::openbsd::gateway {
		$name:
		    gw => $gw;
	    }
	}
    }
}
