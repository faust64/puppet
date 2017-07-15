class rkhunter::scripts {
    if ($rkhunter::vars::slack_hook) {
	$hook    = $rkhunter::vars::slack_hook
	$log_dir = $rkhunter::vars::log_dir

	file {
	    "Install rkhunter slack script":
		content => template("rkhunter/slack.erb"),
		group   => lookup("gid_zero"),
		mode    => "0750",
		owner   => root,
		path    => "/usr/local/sbin/rkhunter_slack",
		require => File["Install rkhunter main configuration"];
	}
    }
}
