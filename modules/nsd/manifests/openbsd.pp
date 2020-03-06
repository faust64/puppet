class nsd::openbsd {
    common::define::lined {
	"Enable nsd on boot":
	    line => "nsd_flags=",
	    path => "/etc/rc.conf.local";
    }

    Common::Define::Lined["Enable nsd on boot"]
	-> File["Prepare NSD for further configuration"]
	-> Common::Define::Service["nsd"]
}
