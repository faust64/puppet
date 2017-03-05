class owncloud {
    include openldap::client
    include owncloud::vars

    case $myoperatingsystem {
	"Debian", "Devuan": {
	    include owncloud::debian
	}
	default: {
	    common::define::patchneeded { "owncloud": }
	}
    }

    include owncloud::config
    include owncloud::jobs
    include owncloud::scripts
    include owncloud::webapp
}
