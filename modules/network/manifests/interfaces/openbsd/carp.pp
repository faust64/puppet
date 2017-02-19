define network::interfaces::openbsd::carp($vhid       = 1,
					  $addr       = "127.0.0.1",
					  $advbase    = hiera("carp_advbase"),
					  $advskew    = hiera("carp_advskew"),
					  $addr_alias = false,
					  $bcast      = false,
					  $carp_pass  = hiera("carp_pass"),
					  $nmask      = "255.0.0.0",
					  $root_if    = false,
					  $routes     = false,
					  $ualias     = false) {
    $fname = "/etc/hostname.carp$vhid"

    if (! defined(File["Install carpctl"])) {
	file {
	    "Install carpctl":
		group  => hiera("gid_zero"),
		mode   => "0750",
		owner  => root,
		path   => "/usr/local/sbin/carpctl",
		source => "puppet:///modules/network/carpctl";
	}
    }

    if (! defined(File["Install carp$vhid interface configuration"])) {
	network::interfaces::openbsd::reload {
	    "carp$vhid":
	}

	file {
	    "Install carp$vhid interface configuration":
		content => template("network/carp.erb"),
		group   => hiera("gid_zero"),
		mode    => "0640",
		notify  => Exec["Reload carp$vhid configuration"],
		owner   => root,
		path    => $fname;
	}
    }
}
