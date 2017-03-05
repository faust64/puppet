class wpasupplicant {
    include wpasupplicant::vars

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include wpasupplicant::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
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
