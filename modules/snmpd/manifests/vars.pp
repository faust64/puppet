class snmpd::vars {
    $snmp_community    = hiera("snmp_community")
    $snmp_conf_dir     = hiera("snmp_conf_dir")
    $snmp_listenaddr   = hiera("snmp_listenaddr")
    $snmp_location     = hiera("snmp_location")
    $snmp_new_syntax   = hiera("snmp_uptodate")
    $snmp_newer_syntax = hiera("snmp_uptodate_new")
    $snmp_sysservices  = hiera("snmp_sysservices")
}
