class ftpproxy::openbsd {
    $main_networks = $ftpproxy::vars::main_networks

    each($main_networks) |$nic| {
	if ($nic['default'] == true) {
	    if ! defined(Exec["Enable ftpproxy on boot"]) {
		include ftpproxy::service

		if ($nic['carpaddr']) {
		    $nat_addr = $nic['carpaddr']
		}
		else {
		    $nat_addr = $nic['addr']
		}

		file_line {
		    "Enable ftpproxy on boot":
			line  => "ftpproxy_flags='-r -a $nat_addr'",
#			match => 'ftpproxy_flags=',
			path  => '/etc/rc.conf.local';
		}

#		File_line["Enable ftpproxy on boot"]
#		    -> Service["ftpproxy"]
	    }
	    else {
		err{ "Looks like you have several default gateways configured": }
	    }
	}
    }
}
