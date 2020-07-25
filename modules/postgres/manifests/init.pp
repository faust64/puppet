# its only purpose being to enable logs rotation:
# use with care / unsuittable for... almost anything / patch needed
class postgres {
    include postgres::vars

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include postgres::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include postgres::debian
	}
	"FreeBSD": {
	    include postgres::freebsd
	}
	"OpenBSD": {
	    include postgres::openbsd
	}
	default: {
	    common::define::patchneeded { "postgres": }
	}
    }

    include postgres::config
    include postgres::profile
    #include postgres::nagios
    include postgres::service
}
