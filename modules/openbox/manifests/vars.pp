class openbox::vars {
    $autostart      = lookup("openbox_autostart_cmd")
    $autostart_file = lookup("openbox_autostart_file")
    $home_dir       = lookup("generic_home_dir")
    $repo           = lookup("puppet_http_repo")
    $runtime_group  = lookup("generic_group")
    $runtime_user   = lookup("generic_user")
}
