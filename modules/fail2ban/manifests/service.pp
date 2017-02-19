class fail2ban::service {
    common::define::service {
	"fail2ban":
	    ensure => running;
    }
}
