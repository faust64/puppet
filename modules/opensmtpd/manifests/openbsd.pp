class opensmtpd::openbsd {
    file_line {
	"Enable Opensmtpd on boot":
	    line => "smtpd_flags=",
	    path => "/etc/rc.conf.local";
    }

    common::define::service {
	"sendmail":
	    ensure => stopped;
    }

    File_line["Enable Opensmtpd on boot"]
	-> Service["sendmail"]
	-> Service["smtpd"]
}
