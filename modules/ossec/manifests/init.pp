class ossec {
    include ossec::vars

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include ossec::debian
	}
	"FreeBSD": {
	    include ossec::freebsd
	}
	default: {
	    common::define::patchneeded { "ossec": }
	}
    }

    if ($ossec::vars::manager == false) {
	include ossec::authd
	include ossec::webapp

	if (0 == 1) {
# if you don't forwrd your logs to ossec, then you may send ossec logs to rsyslog
	    include ossec::rsyslog
	}
    } else {
	include ossec::register
    }

    include ossec::config
    include ossec::filetraq
    include ossec::scripts
    include ossec::service
}
