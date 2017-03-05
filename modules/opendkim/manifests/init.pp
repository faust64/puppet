class opendkim {
    include opendkim::vars

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include opendkim::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include opendkim::debian
	}
	"OpenBSD": {
	    include opendkim::openbsd
	}
	default: {
	    common::define::patchneeded { "opendkim": }
	}
    }

    if ($opendkim::vars::routeto == $fqdn) {
	include opendkim::genkeys
	include opendkim::register
    } else {
	include opendkim::collect
    }

    include opendkim::config
    include opendkim::filetraq
    include opendkim::service
}
