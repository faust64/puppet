class samba::service {
    common::define::service {
	"samba":
	    ensure  => running,
	    pattern => "smbd";
    }
}
