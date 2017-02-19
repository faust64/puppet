class bgpd::scripts {
    file {
	"Bgp application script":
	    group  => hiera("gid_zero"),
	    mode   => "0750",
	    owner  => root,
	    path   => "/usr/local/sbin/bgp_resync",
	    source => "puppet:///modules/bgpd/resync";
    }
}
