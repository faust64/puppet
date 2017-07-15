class libvirt::scripts {
    file {
	"Install libvirt-shut":
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/bin/libvirt-shut",
	    source  => "puppet:///modules/libvirt/libvirt-shut";
    }
}
