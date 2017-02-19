class named {
    include named::vars

    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include named::debian
	}
	"OpenBSD": {
	    include named::openbsd
	}
	default: {
	    common::define::patchneeded { "named": }
	}
    }

    include named::collectd
    include named::config
    include named::filetraq
    include named::munin
    include named::nagios
    include named::scripts
    include named::service

    if (! defined(Class[Common::Tools::Tcpdump])) {
	include common::tools::tcpdump
    }
}
