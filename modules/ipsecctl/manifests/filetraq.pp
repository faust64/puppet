class ipsecctl::filetraq {
    filetraq::define::trac {
	"ipsecctl":
	     pathlist => [ "/etc/ipsec.conf", "/etc/ipsec.d/*" ];
    }
}
