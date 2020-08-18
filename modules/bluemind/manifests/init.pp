class bluemind {
    include bluemind::vars

    include opendkim
    include spamassassin
    if ($bluemind::vars::do_letsencrypt) {
	include certbot
    }

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include bluemind::debian
	}
	default: {
	    common::define::patchneeded { "bluemind": }
	}
    }

    include bluemind::collect
    include bluemind::logrotate
    include bluemind::munin
    include bluemind::nagios
    include bluemind::prometheus
    include bluemind::rsyslog
    include bluemind::scripts
    include bluemind::jobs
}
