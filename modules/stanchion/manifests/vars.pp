class stanchion::vars {
    $admin_key           = hiera("riakcs_admin_key")
    $admin_secret        = hiera("riakcs_admin_secret")
    $binpath             = "/usr/sbin"
    $check_listen        = hiera("riak_listen")
    $dcookie             = hiera("stanchion_dcookie")
    $name_prefix         = hiera("stanchion_name_prefix")
    $nagios_runtime_user = hiera("nagios_runtime_user")
    $riak_master         = hiera("riak_register")
    $runtime_group       = hiera("riak_runtime_group")
    $runtime_user        = hiera("riak_runtime_user")
    $stanchion           = hiera("riakcs_stanchion_host")
    $sudo_conf_dir       = hiera("sudo_conf_dir")

    if ($check_listen == false) {
	$listen = $ipaddress
    } else {
	$listen = $check_listen
    }

    $nodename = "$name_prefix@$listen"
}
