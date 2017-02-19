class elasticsearch::vars {
    $clustername        = hiera("elasticsearch_cluster_name")
    $cluster_hosts      = hiera("elasticsearch_cluster_hosts")
    $cors               = hiera("elasticsearch_http_cors")
    $is_data            = hiera("elasticsearch_is_data")
    $is_master          = hiera("elasticsearch_is_master")
    $kibana_prefix      = hiera("kibana_prefix")
    $listen_addr        = hiera("elasticsearch_listen_addr")
    $munin_conf_dir     = hiera("munin_conf_dir")
    $munin_monitored    = hiera("elasticsearch_munin")
    $munin_probes       = hiera("elasticsearch_munin_probes")
    $munin_service_name = hiera("munin_node_service_name")
    $myname             = hiera("elasticsearch_node_name")
    $replicas           = hiera("elasticsearch_number_of_replicas")
    $retention_open     = hiera("elasticsearch_retention_open")
    $retention_unit     = hiera("elasticsearch_retention_unit")
    $retention_val      = hiera("elasticsearch_retention")
    $shards             = hiera("elasticsearch_number_of_shards")
    $version            = hiera("elasticsearch_version")

    if ($listen_addr) {
	$listen = $listen_addr
    } else {
	$listen = "127.0.0.1"
    }
    if ($myname) {
	$nodename = $myname
    } else {
	$nodename = $hostname
    }
}
