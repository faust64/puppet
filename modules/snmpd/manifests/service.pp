class snmpd::service {
    common::define::service {
	"snmpd":
	    ensure => running;
    }
}
