class wordpress {
    include wordpress::vars
    include common::tools::unzip

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include wordpress::debian
	}
	default: {
	    common::define::patchneeded { "wordpress": }
	}
    }

    include wordpress::config
    include wordpress::filetraq
    include wordpress::ldapauth
    include wordpress::nagios
    include wordpress::scripts
    include wordpress::service
    include wordpress::webapp
}
