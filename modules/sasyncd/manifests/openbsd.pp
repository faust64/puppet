class sasyncd::openbsd {
    if ! defined(Exec["Enable sasyncd on boot"]) {
	common::define::lined {
	    "Enable sasyncd on boot":
		line  => "sasyncd_flags='-vvv'",
#		match => 'sasyncd_flags=',
		path  => "/etc/rc.conf.local";
	}

#	Common::Define::Lined["Enable sasyncd on boot"]
#	    -> Common::Define::Service["sasyncd"]
    }
}
