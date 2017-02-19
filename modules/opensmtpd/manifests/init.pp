class opensmtpd {
    include opensmtpd::vars

    case $operatingsystem {
	"OpenBSD": {
	    include opensmtpd::openbsd
	}
	default: {
	    common::define::patchneeded { "opensmtpd": }
	}
    }

    include opensmtpd::alias
    include opensmtpd::config
    include opensmtpd::service
}
