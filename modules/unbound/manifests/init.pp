class unbound {
    include unbound::vars

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include unbound::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include unbound::debian
	}
	"OpenBSD": {
	    include unbound::openbsd
	}
	default: {
	    common::define::patchneeded { "unbound": }
	}
    }

    if ($unbound::vars::do_public) {
	include unbound::keys
	include unbound::blocklist
	include unbound::scripts
    }

    if ($unbound::vars::do_dnssec) {
	include unbound::dnssec
    }

    include unbound::collectd
    include unbound::config
    include unbound::filetraq
    include unbound::munin
    include unbound::nagios
    include unbound::pixelserver
    include unbound::service

    if ($kernel == "Linux") {
	include unbound::logrotate
    }
    if (! defined(Class["common::tools::tcpdump"])) {
	include common::tools::tcpdump
    }
}
