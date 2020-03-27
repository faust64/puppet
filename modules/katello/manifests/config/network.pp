class katello::config::network {
    katello::define::domain {
	[
	    "intra.unetresgrossebite.com",
	    "faust.intra.unetresgrossebite.com",
	    "friends.intra.unetresgrossebite.com",
	    "unetresgrossebite.com",
	    "vms.intra.unetresgrossebite.com"
	]:
    }

    katello::define::subnet {
	"Faust":
	    base     => "10.42.42",
	    dns_prim => "10.255.255.255",
	    domain   => "faust.intra.unetresgrossebite.com";
	"Friends":
	    base     => "10.42.253",
	    dns_prim => "10.255.255.255",
	    domain   => "friends.intra.unetresgrossebite.com";
	"VMs":
	    base     => "10.42.44",
	    dns_prim => "10.255.255.255",
	    domain   => "vms.intra.unetresgrossebite.com";
    }
}
