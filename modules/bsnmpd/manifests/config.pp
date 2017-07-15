class bsnmpd::config {
    $conf_dir         = $bsnmpd::vars::snmp_conf_dir
    $snmp_community   = $bsnmpd::vars::snmp_community
    $snmp_location    = $bsnmpd::vars::snmp_location
    $snmp_sysservices = $bsnmpd::vars::snmp_sysservices

    file {
	"BSNMPd main configuration":
	    content => template("bsnmpd/bsnmpd.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["bsnmpd"],
	    owner   => root,
	    path    => "$conf_dir/snmpd.config";
    }
}
