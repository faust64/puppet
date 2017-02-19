class openvpn {
    include openvpn::vars
    include openvpn::scripts

    case $operatingsystem {
	"CentOS", "RedHat": {
	    include openvpn::rhel
	}
	"Debian", "Ubuntu": {
	    include openvpn::debian
	}
	"OpenBSD": {
	    include openvpn::openbsd
	}
	default: {
	    common::define::patchneeded { "openvpn": }
	}
    }

    include openvpn::config
    include openvpn::filetraq
    include openvpn::jobs
    include openvpn::munin
    include openvpn::rotate
    include openvpn::service
}
