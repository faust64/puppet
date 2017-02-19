class nfs {
    include nfs::vars

    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include nfs::debian
	}
	"CentOS", "RedHat": {
	    include nfs::rhel
	}
	"FreeBSD", "OpenBSD": { }
	default: {
	    common::define::patchneeded { "nfs": }
	}
    }

    include nfs::config
    include nfs::service
}
