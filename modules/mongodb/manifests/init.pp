class mongodb {
    include mongodb::vars

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include mongodb::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include mongodb::debian
	}
	default: {
	    common::define::patchneeded { "mongodb": }
	}
    }

    include mongodb::backups
    include mongodb::config
    include mongodb::filetraq
    include mongodb::munin
    include mongodb::nagios

    if ($mongodb::vars::do_service) {
	include mongodb::service
    }

    if ($kernel == "Linux") {
	include mongodb::logrotate
    }
}
