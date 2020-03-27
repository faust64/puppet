class unbound::rhel {
    common::define::package {
	"unbound":
    }

    firewalld::define::addrule {
	"tcpdns":
	    port  => 53;
	"udpdns":
	    port  => 53,
	    proto => udp;
    }

    file {
	"Install unbound service defaults":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["unbound"],
	    owner   => root,
	    path    => "/etc/sysconfig/unbound",
	    source  => "puppet:///modules/unbound/sysconfig",
	    require => Package["unbound"];
    }
}
