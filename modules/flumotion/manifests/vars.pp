class flumotion::vars {
    $admin_pass      = hiera("flumotion_admin_pass")
    $admin_user      = hiera("flumotion_admin_user")
    $conf_dir        = hiera("flumotion_conf_dir")
    $home_dir        = hiera("generic_home_dir")
    $forwarder_host  = hiera("flumotion_forwarder_host")
    $forwarder_pass  = hiera("flumotion_forwarder_pass")
    $forwarder_port  = hiera("flumotion_forwarder_port")
    $forwarder_mount = hiera("flumotion_forwarder_mountpoint")
    $local_group     = hiera("generic_group")
    $rruntime_user   = hiera("flumotion_runtime_user")
    $runtime_group   = hiera("flumotion_runtime_group")
    $xruntime_user   = hiera("generic_user")

    if (defined(Class[Xorg])) {
	$runtime_user = $xruntime_user
    }
    else {
	$runtime_user = $rruntime_user
    }
}
