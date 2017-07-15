class pakitiserver::service {
    if ($kernel == "Linux") {
	file {
	    "Install Pakiti Server daily cron":
		group   => lookup("gid_zero"),
		mode    => "0750",
		owner   => root,
		path    => "/etc/cron.daily/pakiti2-server-update",
		require => File["Install Pakiti main configuration"],
		source  => "puppet:///modules/pakitiserver/server-update";
	}
    }
}
