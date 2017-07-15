class kibana::vars {
    $esearch_version = lookup("elasticsearch_version")
    $index_name      = lookup("kibana_index_name")
    $listen_addr     = lookup("elasticsearch_listen_addr")
    $rdomain         = lookup("root_domain")

    if ($listen_addr) {
	$esearch_listen = $listen_addr
    } else {
	$esearch_listen = "127.0.0.1"
    }
}
