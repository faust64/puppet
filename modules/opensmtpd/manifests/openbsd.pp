class opensmtpd::openbsd {
    common::define::lined {
	"Enable Opensmtpd on boot":
	    line => "smtpd_flags=",
	    path => "/etc/rc.conf.local";
    }

    common::define::service {
	"sendmail":
	    ensure => stopped;
    }

    Common::Define::Lined["Enable Opensmtpd on boot"]
	-> Service["sendmail"]
	-> Service["smtpd"]
}
