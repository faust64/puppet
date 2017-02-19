class bsnmpd::vars {
    $snmp_community   = hiera("snmp_community")
    $snmp_conf_dir    = hiera("snmp_conf_dir")
    $snmp_location    = hiera("snmp_location")
    $snmp_sysservices = hiera("snmp_sysservices")
}
