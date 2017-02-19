define network::interfaces::carp($vhid       = 1,
				 $addr       = "127.0.0.1",
				 $advbase    = hiera("carp_advbase"),
				 $advskew    = hiera("carp_advskew"),
				 $addr_alias = false,
				 $bcast      = false,
				 $carp_pass  = hiera("carp_pass"),
				 $nmask      = "255.0.0.0",
				 $root_if    = false,
				 $routes     = false,
				 $ualias     = false) {
    if ! defined(Class[Network::Sysctl::Carp]) {
	include mysysctl::define::carp
    }
    if (! defined(Class[Ifstated])) {
	include ifstated
    }

    case $operatingsystem {
	"OpenBSD": {
	    network::interfaces::openbsd::carp {
		$name:
		    vhid       => $vhid,
		    addr       => $addr,
		    addr_alias => $addr_alias,
		    bcast      => $bcast,
		    nmask      => $nmask,
		    root_if    => $root_if,
		    routes     => $routes,
		    ualias     => $ualias;
	    }
	}
    }
}
