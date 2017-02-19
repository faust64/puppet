class dhcrelay::openbsd {
    $ifs     = $dhcrelay::vars::obsd_ifs
    $targets = $dhcrelay::vars::targets

    if ($ifs != false) {
	$flags = "$ifs$targets"

	file_line {
	    "Enable dhcrelay on boot":
		line  => "dhcrelay_flags='$flags'",
#		match => 'dhcrelay_flags=',
		path  => '/etc/rc.conf.local';
	}

	File_line["Enable dhcrelay on boot"]
	    -> Common::Define::Service["dhcrelay"]
    }
}
