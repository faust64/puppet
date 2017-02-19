class xorg::vars {
    $home_dir      = hiera("generic_home_dir")
    $pass          = hiera("generic_pass")
    $runtime_group = hiera("generic_group")
    $runtime_user  = hiera("generic_user")
    $user_groups   = hiera("generic_groups")
    $with_audio    = hiera("xorg_with_audio")
}
