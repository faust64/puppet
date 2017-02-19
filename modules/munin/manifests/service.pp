class munin::service {
    if ($kernel == "Linux") {
	file {
	    "Install Munin cron jobs":
		source  => "puppet:///modules/munin/cron",
		group   => hiera("gid_zero"),
		mode    => "0644",
		owner   => root,
		path    => "/etc/cron.d/munin",
		require =>
		    [
			File["Install munin-cron script"],
			File["Install munin-graph script"],
			File["Prepare Munin for further configuration"]
		    ];
	}
    }
}
