class flumotion::vars {
    $admin_pass      = lookup("flumotion_admin_pass")
    $admin_user      = lookup("flumotion_admin_user")
    $conf_dir        = lookup("flumotion_conf_dir")
    $home_dir        = lookup("generic_home_dir")
    $forwarder_host  = lookup("flumotion_forwarder_host")
    $forwarder_pass  = lookup("flumotion_forwarder_pass")
    $forwarder_port  = lookup("flumotion_forwarder_port")
    $forwarder_mount = lookup("flumotion_forwarder_mountpoint")
    $local_group     = lookup("generic_group")
    $rruntime_user   = lookup("flumotion_runtime_user")
    $runtime_group   = lookup("flumotion_runtime_group")
    $xruntime_user   = lookup("generic_user")

    if (defined(Class[Xorg])) {
	$runtime_user = $xruntime_user
    }
    else {
	$runtime_user = $rruntime_user
    }
}
