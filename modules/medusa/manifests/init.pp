class medusa {
    include medusa::vars
    include medusa::install
    include common::libs::mediainfo
    include common::tools::unrar

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include medusa::debian
	}
	default: {
	    common::define::patchneeded { "medusa": }
	}
    }

    include medusa::config
    include medusa::nagios
    include medusa::scripts
    include medusa::service
    include medusa::webapp
}
