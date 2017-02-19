class igmpproxy::vars {
    $all_networks   = hiera_hash("vlan_database")
    $local_networks = hiera("active_vlans")
}
