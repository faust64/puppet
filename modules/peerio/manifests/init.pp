class peerio {
    include peerio::vars

    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include peerio::debian
	}
	default: {
	    common::define::patchneeded { "peerio": }
	}
    }

    include peerio::riakssl
    include peerio::config
    include peerio::munin
    include peerio::nagios
    include peerio::rsyslog
    include peerio::service
    include peerio::webapp

    if ($kernel == "Linux") {
	include peerio::logrotate
    }
}
