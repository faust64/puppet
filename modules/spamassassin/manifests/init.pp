class spamassassin {
    include spamassassin::vars

    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include spamassassin::debian
	}
	default: {
	    common::define::patchneeded { "spamassassin": }
	}
    }

    include spamassassin::config
    include spamassassin::filetraq
    include spamassassin::munin
    include spamassassin::nagios
    include spamassassin::service

    if ($spamassassin::vars::routeto == $fqdn) {
	include spamassassin::learn
	include spamassassin::collect
	include spamassassin::push
    } else {
	include spamassassin::register
    }
    if ($kernel == "Linux") {
	include spamassassin::logrotate
    }
    if ($spamassassin::vars::spamassassin_rsyslog == true) {
	include spamassassin::rsyslog
    }
}
