class katello::config::firewalld {
    firewalld::define::addrule {
	"tcpdns":
	    port  => 53;
	"udpdns":
	    port  => 53,
	    proto => udp;
	"dhcp":
	    port  => 67,
	    proto => udp;
	"tftp":
	    port  => 69,
	    proto => udp;
	"docker":
	    port  => 5000;
	"qpid":
	    port  => 5647;
	"ks":
	    port  => 8000;
	"puppet":
	    port  => 8140;
	"scap":
	    port  => 9090;
    }

    $deps =
	[
	    "tcpdns", "udpdns", "dhcp", "tftp", "apache-http",
	    "apache-https", "docker", "qpid", "ks", "puppet", "scap"
	]

    each($deps) |$dep| {
	Firewalld::Define::Addrule[$dep]
	    -> Common::Define::Package["katello"]
    }
}
