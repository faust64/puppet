class snmpd::rhel {
    common::define::package {
	"net-snmp":
    }

    Package["net-snmp"]
	-> File["SNMPd main configuration"]
}
