define network::interfaces::openbsd::vlan($addr     = "127.0.0.1",
					  $ifstate  = false,
				 	  $l2filter = false,
					  $mtu      = false,
				 	  $nmask    = "255.0.0.0",
				 	  $root_if  = false,
					  $routes   = false,
					  $vid      = 1,
					  $vvid     = $vid) {
    $fname = "/etc/hostname.vlan$vvid"

    if ! defined(File["Install vlan$vvid interface configuration"]) {
	network::interfaces::openbsd::reload {
	    "vlan$vvid":
	}

	file {
	    "Install vlan$vvid interface configuration":
		content => template("network/vlan.erb"),
		group   => lookup("gid_zero"),
		mode    => "0640",
		notify  => Exec["Reload vlan$vvid configuration"],
		owner   => root,
		path    => $fname;
	}

	if ($l2filter) {
	    $filter_max_addr = 260

	    file {
		"Install L2 filter configuration on $name":
		    content => template("network/l2filter.erb"),
		    group   => lookup("gid_zero"),
		    mode    => "0640",
		    notify  => Exec["Refresh $name L2 filter"],
		    owner   => root,
		    path    => "/etc/filter.$name.conf";
		"Mount L2 filtered bridge upon $name":
		    content => template("network/bridge-rule.erb"),
		    group   => lookup("gid_zero"),
		    mode    => "0640",
		    notify  => Exec["Refresh $name L2 filter"],
		    owner   => root,
		    path    => "/etc/hostname.bridge$vvid";
	    }

	    exec {
		"Refresh $name L2 filter":
		    command     => "reload_bridge $vvid",
		    path        => "/usr/local/sbin",
		    refreshonly => true,
		    require     =>
			[
			    File["Install reload_bridge script"],
			    File["Install L2 filter configuration on $name"],
			    File["Mount L2 filtered bridge upon $name"]
			];
	    }

	    if (defined(File["Install hwfilter propagation script"])) {
		File["Install hwfilter propagation script"]
		    -> File["Install L2 filter configuration on $name"]
	    }
	}
    }
}
