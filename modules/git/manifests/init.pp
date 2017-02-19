class git {
    include git::vars

    case $operatingsystem {
	"CentOS", "RedHat": {
	    include git::rhel
	}
	"Debian", "Ubuntu": {
	    include git::debian
	}
	default: {
	    common::define::patchneeded { "git": }
	}
    }

    include git::config
    include git::webapp
}
