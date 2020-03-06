define network::interfaces::freebsd::pfsync($parent = false,
					    $peer   = false) {
    common::define::lined {
	"Enable pfsync":
	    line => "pfsync_enable=YES",
	    path => "/etc/rc.conf";
    }

    if ($parent) {
	common::define::lined {
	    "Enable pfsync on $parent":
		line => "pfsync_syncdev=$parent",
		path => "/etc/rc.conf";
	}
    }

    if ($peer) {
	common::define::lined {
	    "Enable pfsync with $peer":
		line => "pfsync_syncpeer=$peer",
		path => "/etc/rc.conf";
	}
    }
}
