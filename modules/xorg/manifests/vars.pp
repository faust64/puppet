class xorg::vars {
    $home_dir      = lookup("generic_home_dir")
    $pass          = lookup("generic_pass")
    $runtime_group = lookup("generic_group")
    $runtime_user  = lookup("generic_user")
    $user_groups   = lookup("generic_groups")
    $with_audio    = lookup("xorg_with_audio")
}
