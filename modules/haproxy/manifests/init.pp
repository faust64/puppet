class haproxy {
    include haproxy::vars

    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include haproxy::debian
	}
	default: {
	    common::define::patchneeded { "haproxy": }
	}
    }

    include haproxy::config
    include haproxy::custom
    include haproxy::rsyslog
    include haproxy::scripts
    include haproxy::service
    include haproxy::ssl
    include haproxy::nagios
    include haproxy::munin
}
