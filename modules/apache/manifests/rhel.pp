class apache::rhel {
    common::define::package {
	[ "httpd", "nagios-plugins-http" ]:
    }

    if ($apache::vars::listen_ports['plain']) {
	firewalld::define::addrule {
	    "apache-http":
		port => $apache::vars::listen_ports['plain'];
	}
    }
    if ($apache::vars::listen_ports['ssl']) {
	firewalld::define::addrule {
	    "apache-https":
		port => $apache::vars::listen_ports['ssl'];
	}
    }

    if ($apache::vars::apache_debugs) {
	common::define::package {
	    "apachetop":
	}
    }
}
