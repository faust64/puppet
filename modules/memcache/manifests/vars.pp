class memcache::vars {
    $conf_dir           = hiera("memcache_conf_dir")
    $listen             = hiera("memcache_listen_addr")
    $max_mem            = hiera("memcache_max_mem")
    $munin_conf_dir     = hiera("munin_conf_dir")
    $munin_monitored    = hiera("memcache_munin")
    $munin_probes       = hiera("memcache_munin_probes")
    $munin_service_name = hiera("munin_node_service_name")
    $runtime_user       = hiera("memcache_runtime_user")
    $service_name       = hiera("memcache_service_name")
}
