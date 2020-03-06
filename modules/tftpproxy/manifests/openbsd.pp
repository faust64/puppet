class tftpproxy::openbsd {
    case $kernelrelease {
	/5\.[3-9]/, /6\.[0-9]/: {
	    common::define::lined {
		"Enable tftpproxy on boot":
		    line  => "tftpproxy_flags=",
		    match => '^tftpproxy_flags=',
		    path  => "/etc/rc.conf";
	    }

	    common::define::service {
		"tftpproxy":
		    ensure => running;
	    }

	    Common::Define::Lined["Enable tftpproxy on boot"]
		-> Service["tftpproxy"]
	}
	default: {
	    notify { "tftpproxy not implemented in current release": }
	}
    }
}
