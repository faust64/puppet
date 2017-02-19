class saslauthd {
    include saslauthd::vars

    case $operatingsystem {
	"CentOS", "RedHat": {
	    include saslauthd::rhel
	}
	"Debian", "Ubuntu": {
	    include saslauthd::debian
	}
	default: {
	    common::define::patchneeded { "saslauthd": }
	}
    }

    include saslauthd::config
    include saslauthd::service

    if ($srvtype == "mail") {
	include saslauthd::postfix
    }
}
