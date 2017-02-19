class slim::vars {
    $autologin    = hiera("slim_auto_login")
    $conf_dir     = hiera("slim_conf_dir")
    $console_cmd  = hiera("slim_console_cmd")
    $login_cmd    = hiera("slim_login_cmd")
    $run_dir      = hiera("slim_run_dir")
    $runtime_user = hiera("generic_user")
    $server_args  = hiera("slim_server_args")
    $suspend_cmd  = hiera("slim_suspend_cmd")
    $theme        = hiera("slim_theme")
    $xauth        = hiera("xorg_xauth")
    $xbin         = hiera("xorg_bin")
}
