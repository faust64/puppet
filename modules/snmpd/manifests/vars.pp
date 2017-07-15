class snmpd::vars {
    $snmp_community    = lookup("snmp_community")
    $snmp_conf_dir     = lookup("snmp_conf_dir")
    $snmp_listenaddr   = lookup("snmp_listenaddr")
    $snmp_location     = lookup("snmp_location")
    $snmp_new_syntax   = lookup("snmp_uptodate")
    $snmp_newer_syntax = lookup("snmp_uptodate_new")
    $snmp_sysservices  = lookup("snmp_sysservices")
}
