class autofs {
    include autofs::vars

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include autofs::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include autofs::debian
	}
	default: {
	    common::define::patchneeded { "autofs": }
	}
    }

    include autofs::config
    include autofs::service
}
