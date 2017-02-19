class snmpd::config {
    $conf_dir         = $snmpd::vars::snmp_conf_dir
    $new_syntax       = $snmpd::vars::snmp_new_syntax
    $newer_syntax     = $snmpd::vars::snmp_newer_syntax
    $snmp_community   = $snmpd::vars::snmp_community
    $snmp_listenaddr  = $snmpd::vars::snmp_listenaddr
    $snmp_location    = $snmpd::vars::snmp_location
    $snmp_sysservices = $snmpd::vars::snmp_sysservices

    if ($snmp_listenaddr) {
	$listen = $snmp_listenaddr
    }
    else {
	$listen = $ipaddress
    }

    file {
	"SNMPd main configuration":
	    content => template("snmpd/snmpd.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0600",
	    notify  => Service["snmpd"],
	    owner   => root,
	    path    => "$conf_dir/snmpd.conf";
    }
}
