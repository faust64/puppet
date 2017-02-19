class network {
    include network::vars
    include mysysctl::define::forwarding
    include mysysctl::define::icmp
    include mysysctl::define::ifqmaxlen
    include mysysctl::define::ipv6
    include mysysctl::define::martians
    include mysysctl::define::mforwarding
    include mysysctl::define::rpf
    include network::scripts

    mysysctl::define::syn {
	"SYN":
    }

    if ($network::vars::main_networks) {
	include network::main
    } else {
	include network::dhclient
    }

    if ($srvtype == "firewall") {
	if ($kernel == "FreeBSD" or $kernel == "OpenBSD") {
	    include relayd
	}
	include network::routed
    }
    if ($network::vars::ipsec_tunnels) {
	include ipsecctl
    }
    if ($network::vars::gre_tunnels) {
	include network::gre
    }
    if ($network::vars::ospf_database) {
	include ospfd
    }
    if ($network::vars::rip_map) {
	include ripd
    }
    if ($network::vars::bgp_database) {
	include bgpd
    }
}
