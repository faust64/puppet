class unbound::openbsd {
    common::define::lined {
	"Enable unbound on boot":
	    line => "unbound_flags=",
	    path => "/etc/rc.conf.local";
    }

    Common::Define::Lined["Enable unbound on boot"]
	-> Common::Define::Service["unbound"]
}
