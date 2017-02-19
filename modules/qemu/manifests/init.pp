class qemu {
    include qemu::vars

    case $operatingsystem {
	"CentOS", "RedHat": { }
	"Debian", "Ubuntu": {
	    include qemu::debian
	}
	"FreeBSD": {
	    include qemu::freebsd
	}
	default: {
	    common::define::patchneeded { "qemu": }
	}
    }
}
