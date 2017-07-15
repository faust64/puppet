class apt::vars {
    $apt_repo       = lookup("puppet_apt_repo")
    $apt_repo_key   = lookup("puppet_apt_repo_key_author")
    $apt_proxy      = lookup("apt_cacher")
    $apt_proxy_port = lookup("apt_proxy_port")
    $contact        = lookup("apt_contact")
    $root_is_ro     = lookup("fstab_root_ro")
    $slack_hook     = lookup("apt_slack_hook_uri")
}
