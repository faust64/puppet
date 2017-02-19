define network::interfaces::gif($innerlocal  = false,
				$innermask   = "255.255.255.255",
				$innerremote = false,
				$local       = "127.0.0.1",
				$loopback    = false,
				$remote      = false,
				$routes      = false) {
    case $operatingsystem {
	"OpenBSD": {
	    network::interfaces::openbsd::gif {
		$name:
		    innerlocal  => $innerlocal,
		    innermask   => $innermask,
		    innerremote => $innerremote,
		    local       => $local,
		    remote      => $remote,
		    routes      => $routes;
	    }

	    if ($loopback) {
		$ifid = regsubst($name, '^gif(\d+)$', '\1')
		network::interfaces::generic {
		    "lo$ifid":
			addr  => $local,
			nmask => "255.255.255.255";
		}
	    }
	}
    }
}
