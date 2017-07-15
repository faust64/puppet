class common::fs::perms {
    $contact      = lookup("generic_contact")
    $slack_hook   = lookup("suspicious_slack_hook_uri")
    $suid_exclude = lookup("fs_legit_suid")

    file {
	"Install permission lookup script":
	    content => template("common/suspicious.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/perms_lookup";
    }

    if ($hostname != "bacula") {
# FIXME: on bacula, scripts may take days to complete
# moreover, there's good changes that our files list may fill in all spaces
# available in /tmp, which in turn would break bacula backups, ...
	cron {
	    "Look for suspicious file permissions":
		command => "/usr/local/sbin/perms_lookup",
		hour    => 8,
		minute  => 12,
		require => File["Install permission lookup script"],
		user    => root,
		weekday => 6;
	}
    }
}
