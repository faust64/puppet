class sabnzbd {
    include sabnzbd::vars
    include common::tools::pip
    include common::tools::unzip
    include sabnzbd::user

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include sabnzbd::debian
	}
	default: {
	    common::define::patchneeded { "sabnzbd": }
	}
    }

    class {
	openldap::pam::setup:
	    with_session => true;
    }

    include sabnzbd::config
    include sabnzbd::filetraq
    include sabnzbd::scripts
    include sabnzbd::service
    include sabnzbd::webapp
}
