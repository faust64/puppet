class ospfd::scripts {
    file {
	"Ospf application script":
	    group  => lookup("gid_zero"),
	    mode   => "0750",
	    owner  => root,
	    path   => "/usr/local/sbin/ospf_resync",
	    source => "puppet:///modules/ospfd/resync";
    }
}
