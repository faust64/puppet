class auditd::service {
    common::define::service {
	"auditd":
	    ensure => running;
    }
}
