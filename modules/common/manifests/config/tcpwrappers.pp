class common::config::tcpwrappers {
    file {
	"Set proper permissions to hosts.allow":
	    ensure => present,
	    group  => lookup("gid_zero"),
	    mode   => "0644",
	    owner  => root,
	    path   => "/etc/hosts.allow";
	"Set proper permissions to hosts.deny":
	    ensure => present,
	    group  => lookup("gid_zero"),
	    mode   => "0644",
	    owner  => root,
	    path   => "/etc/hosts.deny";
    }
}
