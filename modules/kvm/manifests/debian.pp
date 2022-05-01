class kvm::debian {
    if ($lsbdistcodename == "bullseye") {
	common::define::package {
	    [ "bridge-utils", "qemu-system-x86", "vlan" ]:
	}
    } else {
	common::define::package {
	    [ "bridge-utils", "qemu-kvm", "vlan" ]:
	}
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
