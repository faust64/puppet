class qemu {
    include qemu::vars

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include qemu::rhel
	}
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

    include qemu::config
}
