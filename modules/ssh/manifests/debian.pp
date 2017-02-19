class ssh::debian {
    common::define::package {
	[ "openssh-client", "openssh-server" ]:
	    ensure => latest;
    }

    Package["openssh-server"]
	-> File["Set proper permissions to sshd_config"]
}
