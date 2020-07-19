define network::interfaces::gre($comment     = false,
				$innerlocal  = false,
				$innermask   = "255.255.255.255",
				$innerremote = false,
				$local       = "127.0.0.1",
				$loopback    = false,
				$remote      = false,
				$routes      = false) {
    if ! defined(Class["network::sysctl::gre"]) {
	include mysysctl::define::gre
    }

    case $operatingsystem {
	"OpenBSD": {
	    network::interfaces::openbsd::gre {
		$name:
		    comment     => $comment,
		    innerlocal  => $innerlocal,
		    innermask   => $innermask,
		    innerremote => $innerremote,
		    local       => $local,
		    remote      => $remote,
		    routes      => $routes;
	    }

	    if ($loopback) {
		$ifid = regsubst($name, '^gre(\d+)$', '\1')

		network::interfaces::generic {
		    "lo$ifid":
			addr  => $local,
			nmask => "255.255.255.255";
		}

		Network::Interfaces::Generic["lo$ifid"]
		    -> Network::Interfaces::Openbsd::Gre[$name]
	    }
	}
    }
}
