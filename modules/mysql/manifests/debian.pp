class mysql::debian {
    if ($mysql::vars::provider == "oracle") {
	common::define::package {
	    "mysql-server":
	}
    } elsif ($mysql::vars::provider == "mariadb") {
	common::define::package {
	    "mariadb-server":
	}
    } else {
	notify { "Invalid provider '$provider'": }
    }
}
