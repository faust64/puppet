class ripd::scripts {
    file {
	"Rip application script":
	    group  => lookup("gid_zero"),
	    mode   => "0750",
	    owner  => root,
	    path   => "/usr/local/sbin/rip_resync",
	    source => "puppet:///modules/ripd/resync";
    }
}
