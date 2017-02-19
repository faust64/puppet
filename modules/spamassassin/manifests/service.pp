class spamassassin::service {
    common::define::service {
	"spamassassin":
	    ensure => running;
    }
}
