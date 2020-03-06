class dhcrelay::openbsd {
    $ifs     = $dhcrelay::vars::obsd_ifs
    $targets = $dhcrelay::vars::targets

    if ($ifs != false) {
	$flags = "$ifs$targets"

	common::define::lined {
	    "Enable dhcrelay on boot":
		line  => "dhcrelay_flags='$flags'",
#		match => 'dhcrelay_flags=',
		path  => '/etc/rc.conf.local';
	}

	Common::Define::Lined["Enable dhcrelay on boot"]
	    -> Common::Define::Service["dhcrelay"]
    }
}
