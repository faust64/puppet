class sasyncd::openbsd {
    if ! defined(Exec["Enable sasyncd on boot"]) {
	file_line {
	    "Enable sasyncd on boot":
		line  => "sasyncd_flags='-vvv'",
#		match => 'sasyncd_flags=',
		path  => "/etc/rc.conf.local";
	}

#	File_line["Enable sasyncd on boot"]
#	    -> Service["sasyncd"]
    }
}
