class ceph::scripts {
    file {
	"Install ceph-diskspace":
	    group  => hiera("gid_zero"),
	    mode   => "0750",
	    owner  => root,
	    path   => "/usr/local/sbin/ceph-diskspace",
	    source => "puppet:///modules/ceph/diskspace";
    }
}
