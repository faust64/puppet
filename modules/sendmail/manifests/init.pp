class sendmail {
    include sendmail::vars

    case $operatingsystem {
	"FreeBSD": {
	    include sendmail::freebsd
	}
	default: {
	    common::define::patchneeded { "sendmail": }
	}
    }

    include sendmail::alias
    include sendmail::config
    include sendmail::nagios
    include sendmail::service
}
