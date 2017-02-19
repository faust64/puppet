define network::interfaces::openbsd::pfsync($parent = false,
					    $peer   = false) {
    $fname    = "/etc/hostname.pfsync0"
    $has_ospf = $network::vars::has_ospf

    if ! defined(File["$fname"]) {
	network::interfaces::openbsd::reload {
	    "pfsync0":
	}

	file {
	    $fname:
		content => template("network/pfsync.erb"),
		group   => hiera("gid_zero"),
		mode    => "0640",
		notify  => Exec["Reload pfsync0 configuration"],
		owner   => root;
	}
    }
}
