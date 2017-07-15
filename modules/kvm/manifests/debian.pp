class kvm::debian {
    common::define::package {
	"qemu-kvm":
    }

    file {
	"Install libvirt-bin script":
	    group  => lookup("gid_zero"),
	    mode   => "0755",
	    owner  => root,
	    path   => "/usr/local/bin/libvirt-bin",
	    source => "puppet:///modules/kvm/libvirt-bin";
    }
}
