class syslog {
    case $myoperatingsystem {
	"CentOS", "Debian", "Devuan", "Ubuntu", "RedHat": {
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
