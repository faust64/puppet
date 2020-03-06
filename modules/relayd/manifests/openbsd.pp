class relayd::openbsd {
    common::define::lined {
	"Enable relayd on boot":
	    line => "relayd_flags=",
	    path => "/etc/rc.conf.local";
    }

    File["Relayd main configuration"]
	-> Common::Define::Lined["Enable relayd on boot"]
	-> Service["relayd"]
}
