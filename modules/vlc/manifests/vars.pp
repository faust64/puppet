class vlc::vars {
    $home_dir      = hiera("generic_home_dir")
    $runtime_group = hiera("generic_group")
    $runtime_user  = hiera("generic_user")
}
