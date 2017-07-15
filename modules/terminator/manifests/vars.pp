class terminator::vars {
    $bgcolor       = lookup("terminator_background")
    $fgcolor       = lookup("terminator_foreground")
    $font          = lookup("terminator_font")
    $home_dir      = lookup("generic_home_dir")
    $runtime_group = lookup("generic_group")
    $runtime_user  = lookup("generic_user")
    $history       = lookup("terminator_history")

    $user_conf_dir = "$home_dir/$runtime_user/.config"
}
