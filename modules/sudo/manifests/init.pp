class sudo {
    include sudo::vars

    case $operatingsystem {
	"CentOS", "RedHat": {
	    include sudo::rhel
	}
	"Debian", "Ubuntu": {
	    include sudo::debian
	}
	"FreeBSD": {
	    include sudo::freebsd
	}
    }

    include sudo::config
    include sudo::filetraq
}
