class elasticsearch::vars {
    $clustername         = lookup("elasticsearch_cluster_name")
    $cors                = lookup("elasticsearch_http_cors")
    $is_data             = lookup("elasticsearch_is_data")
    $is_master           = lookup("elasticsearch_is_master")
    $kibana_prefix       = lookup("kibana_prefix")
    $listen_addr         = lookup("elasticsearch_listen_addr")
    $munin_conf_dir      = lookup("munin_conf_dir")
    $munin_monitored     = lookup("elasticsearch_munin")
    $munin_probes        = lookup("elasticsearch_munin_probes")
    $munin_service_name  = lookup("munin_node_service_name")
    $myname              = lookup("elasticsearch_node_name")
    $nagios_runtime_user = lookup("nagios_runtime_user")
    $nagios_plugins_dir  = lookup("nagios_plugins_dir")
    $replicas            = lookup("elasticsearch_number_of_replicas")
    $retention_open      = lookup("elasticsearch_retention_open")
    $retention_unit      = lookup("elasticsearch_retention_unit")
    $retention_val       = lookup("elasticsearch_retention")
    $shards              = lookup("elasticsearch_number_of_shards")
    $sudo_conf_dir       = lookup("sudo_conf_dir")
    $version             = lookup("elasticsearch_version")

    if ($listen_addr) { $listen = $listen_addr }
    else { $listen = "127.0.0.1" }
    if ($myname) { $nodename = $myname }
    else { $nodename = $hostname }
    if ($version == "7.x" and lookup("elasticsearch_cluster_hosts") == false) {
	$cluster_hosts = [ $listen ]
    } else { $cluster_hosts = lookup("elasticsearch_cluster_hosts") }
}
