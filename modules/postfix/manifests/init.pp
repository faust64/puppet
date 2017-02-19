class postfix {
    include postfix::vars

    case $operatingsystem {
	"CentOS", "RedHat": {
	    include postfix::rhel
	}
	"Debian", "Ubuntu": {
	    include postfix::debian
	}
	default: {
	    common::define::patchneeded { "postfix": }
	}
    }

    include postfix::alias
    include postfix::config
    include postfix::filetraq
    include postfix::munin
    include postfix::nagios
    include postfix::service

    if ($srvtype == "mail") {
	include postfix::relay
    }
    if ($kernel == "Linux") {
	include postfix::rsyslog
    }
}
