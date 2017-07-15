class kvm::scripts {
    file {
	"Install VEdeploy":
	    group  => lookup("gid_zero"),
	    mode   => "0750",
	    owner  => root,
	    path   => "/usr/local/sbin/VEdeploy",
	    source => "puppet:///modules/kvm/VEdeploy";
    }
}
