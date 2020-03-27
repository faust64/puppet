class mysql::rhel {
    common::define::package {
	"mysql-server":
    }

    if ($mysql::vars::bind_addr != "127.0.0.1") {
	firewalld::define::addrule {
	    "mysql":
		port => 3306;
	}
    }
}
