class apt::vars {
    $apt_repo       = hiera("puppet_apt_repo")
    $apt_repo_key   = hiera("puppet_apt_repo_key_author")
    $apt_proxy      = hiera("apt_cacher")
    $apt_proxy_port = hiera("apt_proxy_port")
    $contact        = hiera("apt_contact")
    $root_is_ro     = hiera("fstab_root_ro")
    $slack_hook     = hiera("apt_slack_hook_uri")
}
