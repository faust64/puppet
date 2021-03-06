define network::interfaces::carp($vhid       = 1,
				 $addr       = "127.0.0.1",
				 $advbase    = lookup("carp_advbase"),
				 $advskew    = lookup("carp_advskew"),
				 $addr_alias = false,
				 $bcast      = false,
				 $carp_pass  = lookup("carp_pass"),
				 $mtu        = false,
				 $nmask      = "255.0.0.0",
				 $root_if    = false,
				 $routes     = false,
				 $ualias     = false) {
    if ! defined(Class["network::sysctl::carp"]) {
	include mysysctl::define::carp
    }
    if (! defined(Class["ifstated"])) {
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
		    mtu        => $mtu,
		    nmask      => $nmask,
		    root_if    => $root_if,
		    routes     => $routes,
		    ualias     => $ualias;
	    }

	    if (! defined(Nagios::Define::Probe["carp"])) {
		nagios::define::probe {
		    "carp":
			description   => "$fqdn CARP status consistency",
			servicegroups => "network",
			use           => "critical-service";
		}
	    }
	}
    }
}
