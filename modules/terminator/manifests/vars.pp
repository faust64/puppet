class terminator::vars {
    $bgcolor       = hiera("terminator_background")
    $fgcolor       = hiera("terminator_foreground")
    $font          = hiera("terminator_font")
    $home_dir      = hiera("generic_home_dir")
    $runtime_group = hiera("generic_group")
    $runtime_user  = hiera("generic_user")
    $history       = hiera("terminator_history")

    $user_conf_dir = "$home_dir/$runtime_user/.config"
}
