class git {
    include git::vars

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include git::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include git::debian
	}
	default: {
	    common::define::patchneeded { "git": }
	}
    }

    include git::config
    include git::webapp
}
