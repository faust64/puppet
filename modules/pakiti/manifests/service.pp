class pakiti::service {
    if ($kernel == "Linux") {
	file {
	    "Install Pakiti daily cron":
		group   => hiera("gid_zero"),
		mode    => "0750",
		owner   => root,
		path    => "/etc/cron.daily/pakiti2-client-update",
		require => File["Install Pakiti main configuration"],
		source  => "puppet:///modules/pakiti/client-update";
	}
    } else {
	file {
	    "Install Pakiti update script":
		group   => hiera("gid_zero"),
		mode    => "0750",
		owner   => root,
		path    => "/usr/local/sbin/pakiti2-client-update",
		require => File["Install Pakiti main configuration"],
		source  => "puppet:///modules/pakiti/client-update";
	}

	cron {
	    "Report to pakiti":
		command => "/usr/local/sbin/pakiti2-client-update >/dev/null 2>&1",
		hour    => 6,
		minute  => "32",
		require => File["Install Pakiti update script"],
		user    => root;
	}
    }
}
