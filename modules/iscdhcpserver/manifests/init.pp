class iscdhcpserver {
    include iscdhcpserver::vars

    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include iscdhcpserver::debian
	}
	"OpenBSD": {
	    include iscdhcpserver::openbsd
#	    include dhcpd
	}
	default: {
	    common::define::patchneeded { "isc-dhcp-server": }
	}
    }

    include iscdhcpserver::collect
    include iscdhcpserver::config
    include iscdhcpserver::service
    include dhcpd::nagios
}
