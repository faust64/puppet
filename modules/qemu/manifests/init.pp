class qemu {
    include qemu::vars

    case $myoperatingsystem {
	"CentOS", "RedHat": { }
	"Debian", "Devuan", "Ubuntu": {
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
