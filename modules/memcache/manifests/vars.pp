class memcache::vars {
    $conf_dir           = lookup("memcache_conf_dir")
    $listen             = lookup("memcache_listen_addr")
    $max_mem            = lookup("memcache_max_mem")
    $munin_conf_dir     = lookup("munin_conf_dir")
    $munin_monitored    = lookup("memcache_munin")
    $munin_probes       = lookup("memcache_munin_probes")
    $munin_service_name = lookup("munin_node_service_name")
    $runtime_user       = lookup("memcache_runtime_user")
    $service_name       = lookup("memcache_service_name")
}
