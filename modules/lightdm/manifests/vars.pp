class lightdm::vars {
    $autologin    = hiera("lightdm_auto_login")
    $conf_dir     = hiera("lightdm_conf_dir")
    $runtime_user = hiera("generic_user")
}
