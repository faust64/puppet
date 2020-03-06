class ftpproxy::openbsd {
    $main_networks = $ftpproxy::vars::main_networks

    file {
	"Install Ftp-Proxy custom rc script":
	    group  => hiera("gid_zero"),
	    mode   => "0555",
	    owner  => root,
	    path   => "/etc/rc.d/ftpproxy",
	    source => "puppet:///modules/ftpproxy/ftpproxy";
    }

    File["Install Ftp-Proxy custom rc script"]
	-> Service["ftpproxy"]

    each($main_networks) |$nic| {
	if ($nic['default'] == true) {
	    if ! defined(Exec["Enable ftpproxy on boot"]) {
		include ftpproxy::service

		if ($nic['carpaddr']) {
		    $nat_addr = $nic['carpaddr']
		} else {
		    $nat_addr = $nic['addr']
		}

		common::define::lined {
		    "Enable ftpproxy on boot":
			line  => "ftpproxy_flags='-r -a $nat_addr'",
			match => '^ftpproxy_flags=',
			path  => '/etc/rc.conf.local';
		}

		Common::Define::Lined["Enable ftpproxy on boot"]
		    -> Service["ftpproxy"]
	    } else {
		err{ "Looks like you have several default gateways configured": }
	    }
	}
    }
}
