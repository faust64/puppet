class xinetd::service {
    common::define::service {
	"xinetd":
	    ensure    => running,
	    hasstatus => false,
	    pattern   => "xinetd";
    }
}
