class ossec::scripts {
    $cache_ip   = $ossec::vars::cache_ip
    $slack_hook = $ossec::vars::slack_hook

    if ($slack_hook) {
	file {
	    "Install OSSEC slack notification script":
		content => template("ossec/slack.erb"),
		group   => hiera("gid_zero"),
		mode    => "0750",
		owner   => root,
		path    => "/var/ossec/active-response/bin/ossec-slack.sh";
	}
    }
}
