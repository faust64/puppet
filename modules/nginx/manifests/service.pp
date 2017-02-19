class nginx::service {
    common::define::service {
	"nginx":
	    ensure => running;
    }

    if ($nginx::vars::with_cgi == true) {
	common::define::service {
	    "fcgiwrap":
		ensure => running;
	}
    }
}
