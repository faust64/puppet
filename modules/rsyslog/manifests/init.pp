class rsyslog {
    include rsyslog::vars

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include rsyslog::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include rsyslog::debian
	}
	"FreeBSD": {
	    include rsyslog::freebsd
	}
	"OpenBSD": {
	    include rsyslog::openbsd
	}
	default: {
	    common::define::patchneeded { "rsyslog": }
	}
    }

    include rsyslog::collect
    include rsyslog::config
    include rsyslog::filetraq
    include rsyslog::nagios
    include rsyslog::retransmit
    include rsyslog::rsyslog
    include rsyslog::service
    include rsyslog::store

    if ($rsyslog::vars::listen) {
	include rsyslog::collectscripts
	include rsyslog::jobs
    }
    if ($kernel == "Linux") {
	include rsyslog::logrotate
    }
    if ($rsyslog::vars::do_tls) {
	include rsyslog::tls
    }
    if ($rsyslog::vars::via_stunnel) {
	include rsyslog::stunnel
    }
}
