class isakmpd::openbsd {
    $args = $isakmpd::vars::args

    common::define::lined {
	"Enable isakmpd on boot":
	    line  => "isakmpd_flags='$args'",
#	    match => 'isakmpd_flags=',
	    path  => "/etc/rc.conf.local";
    }

    Common::Define::Lined["Enable isakmpd on boot"]
	-> File["Install Isakmpd main configuration"]
#	-> Service["isakmpd"]
}
