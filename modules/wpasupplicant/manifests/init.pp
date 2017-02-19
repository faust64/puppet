class wpasupplicant {
    include wpasupplicant::vars

    case $operatingsystem {
	"CentOS", "RedHat": {
	    include wpasupplicant::rhel
	}
	"Debian", "Ubuntu": {
	    include wpasupplicant::debian
	}
	"FreeBSD": { }
	"OpenBSD": {
	    include wpasupplicant::openbsd
	}
	default: {
	    common::define::patchneeded { "wpasupplicant": }
	}
    }

    include wpasupplicant::config
#   include wpasupplicant::service
}
