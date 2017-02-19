class xen::scripts {
    file {
	"Install VEdeploy":
	    group  => hiera("gid_zero"),
	    mode   => "0750",
	    owner  => root,
	    path   => "/usr/local/sbin/VEdeploy",
	    source => "puppet:///modules/xen/VEdeploy";
    }
}
