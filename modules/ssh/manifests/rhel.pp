class ssh::rhel {
    common::define::package {
	[ "openssh-clients", "openssh-server" ]:
	    ensure => latest;
    }

    firewalld::define::addrule {
	"ssh":
	    port => $ssh::vars::ssh_port;
    }

    Package["openssh-server"]
	-> File["Set proper permissions to sshd_config"]
}
