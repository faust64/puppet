class rkhunter::jobs {
    if ($rkhunter::vars::slack_hook) {
	file {
	    "Install RKhunter weekly scan job":
		group   => lookup("gid_zero"),
		mode    => "0644",
		owner   => root,
		path    => "/etc/cron.weekly/rkhunter_scan",
		require => File["Install rkhunter slack script"],
		source  => "puppet:///modules/rkhunter/cron-scan";
	}
    }
}
