class git::github {
    $backup_dir      = $git::vars::gh_backup_dir
    $contact         = $git::vars::contact
    $github_org      = $git::vars::gh_backup_org
    $github_token    = $git::vars::gh_backup_token
    $github_username = $git::vars::gh_backup_username
    $slack_hook      = $git::vars::gh_backup_slack_hook

    if ($github_username and $github_token) {
	file {
	    "Install GitHub backup script":
		content => template("git/github_backup.erb"),
		group   => hiera("gid_zero"),
		mode    => "0750",
		owner   => root,
		path    => "/usr/local/sbin/GitHubbackup";
	}

	cron {
	    "Backup GitHub Repositories":
		command => "/usr/local/sbin/GitHubbackup >/dev/null 2>&1",
		hour    => 18,
		minute  => 18,
		require => File["Install GitHub backup script"],
		user    => root;
	}

    } else {
	notify {
	    "GitHub backups enabled while API username and or token are not defined":
	}
    }
}
