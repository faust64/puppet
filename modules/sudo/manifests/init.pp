class sudo {
    include sudo::vars

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include sudo::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include sudo::debian
	}
	"FreeBSD": {
	    include sudo::freebsd
	}
    }

    include sudo::config
    include sudo::filetraq
}
