class unbound::rhel {
    common::define::package {
	"unbound":
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
