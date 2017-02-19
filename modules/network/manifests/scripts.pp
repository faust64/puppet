class network::scripts {
    file {
	"Install AS-LS script":
	    group  => hiera("gid_zero"),
	    mode   => "0755",
	    owner  => root,
	    path   => "/usr/local/bin/asls",
	    source => "puppet:///modules/network/asls";
	"Install abuseLookup script":
	    group  => hiera("gid_zero"),
	    mode   => "0755",
	    owner  => root,
	    path   => "/usr/local/bin/abuseLookup",
	    source => "puppet:///modules/network/abuseLookup";
    }

    if ($operatingsystem == "OpenBSD") {
	file {
	    "Install reload_bridge script":
		group  => hiera("gid_zero"),
		mode   => "0750",
		owner  => root,
		path   => "/usr/local/sbin/reload_bridge",
		source => "puppet:///modules/network/reload_bridge";
	}
    }
}
