define network::interfaces::openbsd::gre($comment     = false,
					 $innerlocal  = false,
					 $innermask   = "255.255.255.255",
					 $innerremote = false,
					 $local       = "127.0.0.1",
					 $mtu         = 1300,
					 $remote      = false,
					 $routes      = false) {
    $fname = "/etc/hostname.gre$name"

    if (! defined(File["Install grectl"])) {
	file {
	    "Install grectl":
		group  => lookup("gid_zero"),
		mode   => "0750",
		owner  => root,
		path   => "/usr/local/sbin/grectl",
		source => "puppet:///modules/network/grectl";
	}
    }

    if ! defined(File["$fname"]) {
	network::interfaces::openbsd::reload {
	    "gre$name":
	}

	file {
	    $fname:
		content => template("network/gre.erb"),
		group   => lookup("gid_zero"),
		mode    => "0640",
		notify  => Exec["Reload gre$name configuration"],
		owner   => root;
	}
    }
}
