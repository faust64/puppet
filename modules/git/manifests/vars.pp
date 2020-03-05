class git::vars {
    $backup_github        = lookup("git_backup_github")
    $backup_dir           = lookup("gitlab_backups_dir")
    $contact              = lookup("backup_contact")
    $author_name          = lookup("git_gitmaster_name")
    $author_email         = lookup("git_gitmaster_mail")
    $gh_backup_org        = lookup("github_backups_organization")
    $gh_backup_slack_hook = lookup("github_backups_slack_hook")
    $gh_backup_token      = lookup("github_backups_token")
    $gh_backup_username   = lookup("github_backups_username")
    $gh_backup_dir        = lookup("github_backups_dir")
    $github_appid         = lookup("gitlab_github_appid")
    $github_appsecret     = lookup("gitlab_github_appsecret")
    $gitlist_vers         = "0.5.0"
    $ldap_pass            = lookup("gitlab_ldap_bind_passphrase")
    $ldap_searchuser      = lookup("gitlab_searchuser")
    $ldap_slave           = lookup("openldap_ldap_slave")
    $ldap_user            = lookup("gitlab_ldap_bind_user")
    $ldap_userfilter      = lookup("gitlab_user_filter")
    $mailrelay            = lookup("mail_mx")
    $rdomain              = lookup("root_domain")
    $repo_root            = lookup("git_repo_root")
    $rootpw               = lookup("gitlab_rootpw")
    $rsyslog_conf_dir     = lookup("rsyslog_conf_dir")
    $rsyslog_service_name = lookup("rsyslog_service_name")
    $rsyslog_version      = lookup("rsyslog_version")
    $slack_hook           = lookup("gitlab_slack_hook_uri")
    $with_gitlab          = lookup("git_with_gitlab")
    $with_gitlist         = lookup("git_with_gitlist")
}
