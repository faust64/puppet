class kibana::vars {
    $esearch_version = hiera("elasticsearch_version")
    $index_name      = hiera("kibana_index_name")
    $listen_addr     = hiera("elasticsearch_listen_addr")
    $rdomain         = hiera("root_domain")

    if ($listen_addr) {
	$esearch_listen = $listen_addr
    } else {
	$esearch_listen = "127.0.0.1"
    }
}
