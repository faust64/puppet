class aide {
    include aide::vars

    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include aide::debian
	}
	"CentOS", "RedHat": {
	    include aide::rhel
	}
	default: {
	    common::define::patchneeded { "aide": }
	}
    }

    include aide::config
    include aide::filetraq
    include aide::jobs
    include aide::scripts
    include aide::setup
}
