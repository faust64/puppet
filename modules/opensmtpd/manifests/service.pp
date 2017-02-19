class opensmtpd::service {
    common::define::service {
	"smtpd":
	    ensure => running;
    }
}
