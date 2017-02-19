class syslog::service {
    common::define::service {
	"syslogd":
	    ensure => running;
    }
}
