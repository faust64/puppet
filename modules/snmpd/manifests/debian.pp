class snmpd::debian {
    common::define::package {
	"snmpd":
    }

    file {
	"Install snmpd service defaults":
	    group  => hiera("gid_zero"),
	    mode   => "0644",
	    notify => Service["snmpd"],
	    owner  => root,
	    path   => "/etc/default/snmpd",
	    source => "puppet:///modules/snmpd/defaults";
    }

    Package["snmpd"]
	-> File["Install snmpd service defaults"]
	-> File["SNMPd main configuration"]
}
