class ssh::rhel {
    common::define::package {
	[ "openssh-clients", "openssh-server" ]:
	    ensure => latest;
    }

    Package["openssh-server"]
	-> File["Set proper permissions to sshd_config"]
}
