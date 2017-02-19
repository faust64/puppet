class syslog {
    case $operatingsystem {
	"CentOS", "Debian", "Ubuntu", "RedHat": {
	    include rsyslog
	}
	"FreeBSD", "OpenBSD": {
	    include syslog::openbsd
	}
	"FreeBSD", "OpenBSD": {
	    include syslog::syslog
	}
	default: {
	    common::define::patchneeded { "syslog": }
	}
    }
}
