class git::webapp {
    if ($git::vars::with_gitlist == true) {
	include git::gitlist
    }
    if ($git::vars::with_gitlab == true) {
	include git::gitlab
	include git::rsyslog
    }
    if ($git::vars::backup_github) {
	include git::github
    }
}
