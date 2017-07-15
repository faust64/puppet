class muninnode::vars {
    $mdraid                  = lookup("nagios_md_raid")
    $munin_conf_dir          = lookup("munin_conf_dir")
    $munin_group             = lookup("munin_group")
    $munin_ip                = lookup("munin_ip")
    $munin_log_dir           = lookup("munin_log_dir")
    $munin_log_level         = lookup("munin_log_level")
    $munin_node_listenaddr   = lookup("munin_node_listenaddr")
    $munin_node_service_name = lookup("munin_node_service_name")
    $munin_physical_probes   = lookup("munin_physical_probes")
    $munin_plugins_dir       = lookup("munin_plugins_dir")
    $munin_pooler            = lookup("munin_pooler")
    $munin_nat_addr          = lookup("munin_nat_addr")
    $munin_nat_port          = lookup("munin_nat_port")
    $munin_port              = lookup("munin_port")
    $munin_probes            = lookup("munin_probes")
    $munin_purge_probes      = lookup("munin_purge_probes")
    $munin_run_dir           = lookup("munin_run_dir")
    $munin_runtime_group     = lookup("munin_runtime_group")
    $munin_runtime_user      = lookup("munin_runtime_user")
    $munin_timeout           = lookup("munin_timeout")
    $munin_user              = lookup("munin_user")
    $munin_sensors           = lookup("munin_sensors")
    $munin_time              = lookup("munin_time_probes")

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
