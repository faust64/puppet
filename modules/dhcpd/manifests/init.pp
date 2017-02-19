class dhcpd {
    include dhcpd::vars

    case $operatingsystem {
	"Debian", "Ubuntu": {
	    notify { "Use ISCDHCPDSERVER module instead!": }
	}
	"OpenBSD": {
	    include dhcpd::openbsd
	}
	default: {
	    common::define::patchneeded { "dhcpd": }
	}
    }

    include dhcpd::config
    include dhcpd::nagios
    include dhcpd::service
}
