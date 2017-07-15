define network::interfaces::openbsd::generic($addr       = false,
					     $addr_alias = false,
					     $hwaddr     = false,
					     $ifstate    = "up",
					     $mtu        = false,
					     $nmask      = false,
					     $trunk      = false,
					     $routes     = false,
					     $ualias     = false) {
    $fname = "/etc/hostname.$name"

    if ! defined(File["Install $name interface configuration"]) {
	network::interfaces::openbsd::reload {
	    "$name":
	}

	file {
	    "Install $name interface configuration":
		content => template("network/generic.erb"),
		group   => lookup("gid_zero"),
		mode    => "0640",
		notify  => Exec["Reload $name configuration"],
		owner   => root,
		path    => $fname;
	}
    }
}
