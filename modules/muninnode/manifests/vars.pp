class muninnode::vars {
    $mdraid                  = hiera("nagios_md_raid")
    $munin_conf_dir          = hiera("munin_conf_dir")
    $munin_group             = hiera("munin_group")
    $munin_ip                = hiera("munin_ip")
    $munin_log_dir           = hiera("munin_log_dir")
    $munin_log_level         = hiera("munin_log_level")
    $munin_node_listenaddr   = hiera("munin_node_listenaddr")
    $munin_node_service_name = hiera("munin_node_service_name")
    $munin_physical_probes   = hiera("munin_physical_probes")
    $munin_plugins_dir       = hiera("munin_plugins_dir")
    $munin_pooler            = hiera("munin_pooler")
    $munin_nat_addr          = hiera("munin_nat_addr")
    $munin_nat_port          = hiera("munin_nat_port")
    $munin_port              = hiera("munin_port")
    $munin_probes            = hiera("munin_probes")
    $munin_purge_probes      = hiera("munin_purge_probes")
    $munin_run_dir           = hiera("munin_run_dir")
    $munin_runtime_group     = hiera("munin_runtime_group")
    $munin_runtime_user      = hiera("munin_runtime_user")
    $munin_timeout           = hiera("munin_timeout")
    $munin_user              = hiera("munin_user")
    $munin_sensors           = hiera("munin_sensors")
    $munin_time              = hiera("munin_time_probes")

    if ($munin_node_listenaddr) {
	$listen = $munin_node_listenaddr
    } else {
	$listen = $ipaddress
    }
    if ($munin_nat_addr) {
	$remoteaddr = $munin_nat_addr
    } else {
	$remoteaddr = $listen
    }
    if ($munin_nat_port) {
	$remoteport = $munin_nat_port
    } else {
	$remoteport = $munin_port
    }
}
