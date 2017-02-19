class rkhunter {
    include rkhunter::vars

    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include rkhunter::debian
	}
	"CentOS", "RedHat": {
	    include rkhunter::rhel
	}
	default: {
	    common::define::patchneeded { "rkhunter": }
	}
    }

    include rkhunter::config
    include rkhunter::filetraq
    include rkhunter::jobs
    include rkhunter::scripts
}
