class tftpproxy::openbsd {
    case $kernelrelease {
	/5\.[3-9]/: {
	    file_line {
		"Enable tftpproxy on boot":
		    line => "tftpproxy_flags=",
		    path => "/etc/rc.conf.local";
	    }

	    common::define::service {
		"tftpproxy":
		    ensure => running;
	    }

	    File_line["Enable tftpproxy on boot"]
		-> Service["tftpproxy"]
	}
	default: {
	    notify { "tftpproxy not implemented in current release": }
	}
    }
}
