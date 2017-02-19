class autofs {
    include autofs::vars

    case $operatingsystem {
	"CentOS", "RedHat": {
	    include autofs::rhel
	}
	"Debian", "Ubuntu": {
	    include autofs::debian
	}
	default: {
	    common::define::patchneeded { "autofs": }
	}
    }

    include autofs::config
    include autofs::service
}
