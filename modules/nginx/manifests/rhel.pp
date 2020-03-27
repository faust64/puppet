class nginx::rhel {
    common::define::package {
	[ "nginx", "nagios-plugins-http" ]:
    }

    if ($nginx::vars::listen_ports['plain']) {
	firewalld::define::addrule {
	    "nginx-http":
		port => $nginx::vars::listen_ports['plain'];
	}
    }
    if ($nginx::vars::listen_ports['ssl']) {
	firewalld::define::addrule {
	    "nginx-https":
		port => $nginx::vars::listen_ports['ssl'];
	}
    }

    Common::Define::Package["nginx"]
	-> File["Drop nginx default enabled configuration"]
	-> Common::Define::Service["nginx"]
}
