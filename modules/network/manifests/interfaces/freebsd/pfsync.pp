define network::interfaces::freebsd::pfsync($parent = false,
					    $peer   = false) {
    file_line {
	"Enable pfsync":
	    line => "pfsync_enable=YES",
	    path => "/etc/rc.conf";
    }

    if ($parent) {
	file_line {
	    "Enable pfsync on $parent":
		line => "pfsync_syncdev=$parent",
		path => "/etc/rc.conf";
	}
    }

    if ($peer) {
	file_line {
	    "Enable pfsync with $peer":
		line => "pfsync_syncpeer=$peer",
		path => "/etc/rc.conf";
	}
    }
}
