class ipfw::freebsd {
    common::define::lined {
	"Enable ipfw on boot":
	    line => 'firewall_type=\"/etc/ipfwrc\"',
	    path => "/etc/rc.conf";
    }

    Common::Define::Lined["Enable ipfw on boot"]
	-> Common::Define::Service["ipfw"]
}
