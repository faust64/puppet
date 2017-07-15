class igmpproxy::vars {
    $all_networks   = lookup("vlan_database", {merge => hash})
    $local_networks = lookup("active_vlans")
}
