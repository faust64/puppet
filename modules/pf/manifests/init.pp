class pf {
    include pf::vars
    include snort

    case $operatingsystem {
	"FreeBSD": {
	    include pf::freebsd
	}
	"OpenBSD": {
	    include pf::openbsd
	}
	default: {
	    common::define::patchneeded { "pf": }
	}
    }

    include pf::config
    include pf::filetraq
    include pf::glpi
    include pf::ipsec
    include pf::munin
    include pf::nagios
    include pf::openvpn
    include pf::private
    include pf::public
    include pf::qos
    include pf::scripts
    include pf::service

    if ($pf::vars::gre_tunnels) {
	include pf::gre
    }
    if ($pf::vars::bgp_database) {
	include pf::bgp
    }
    if ($pf::vars::ospf_database) {
	include pf::ospf
    }
    if ($pf::vars::rip_map) {
	include pf::rip
    }
}
