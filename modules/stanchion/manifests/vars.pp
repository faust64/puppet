class stanchion::vars {
    $admin_key           = lookup("riakcs_admin_key")
    $admin_secret        = lookup("riakcs_admin_secret")
    $binpath             = "/usr/sbin"
    $check_listen        = lookup("riak_listen")
    $dcookie             = lookup("stanchion_dcookie")
    $name_prefix         = lookup("stanchion_name_prefix")
    $nagios_runtime_user = lookup("nagios_runtime_user")
    $riak_master         = lookup("riak_register")
    $runtime_group       = lookup("riak_runtime_group")
    $runtime_user        = lookup("riak_runtime_user")
    $stanchion           = lookup("riakcs_stanchion_host")
    $sudo_conf_dir       = lookup("sudo_conf_dir")

    if ($check_listen == false) {
	$listen = $ipaddress
    } else {
	$listen = $check_listen
    }

    $nodename = "$name_prefix@$listen"
}
