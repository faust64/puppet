class openbox::vars {
    $autostart      = hiera("openbox_autostart_cmd")
    $autostart_file = hiera("openbox_autostart_file")
    $download       = hiera("download_cmd")
    $home_dir       = hiera("generic_home_dir")
    $repo           = hiera("puppet_http_repo")
    $runtime_group  = hiera("generic_group")
    $runtime_user   = hiera("generic_user")
}
