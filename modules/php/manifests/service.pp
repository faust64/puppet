class php::service {
    if ($php::vars::srvname != false) {
	common::define::service {
	    $php::vars::srvname:
	}
    }

    if ($php::vars::is_fpm == true) {
	php::define::pool {
	    "www":
		ensure => "absent";
	}
    }
}
