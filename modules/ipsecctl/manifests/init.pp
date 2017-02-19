class ipsecctl {
    include ipsecctl::vars
    include mysysctl::define::ipsec
    include mysysctl::define::ipcomp

    case $operatingsystem {
	"OpenBSD": {
	    include ipsecctl::openbsd
	}
    }

    include ipsecctl::config
    include ipsecctl::filetraq
    include ipsecctl::jobs
    include ipsecctl::sasyncd
    include ipsecctl::scripts
    include ipsecctl::tunnels
}
