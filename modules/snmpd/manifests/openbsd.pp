class snmpd::openbsd {
    common::define::lined {
	"Enable snmpd on boot":
	    line => "snmpd_flags=",
	    path => "/etc/rc.conf.local";
    }

    Common::Define::Lined["Enable snmpd on boot"]
	-> Common::Define::Service["snmpd"]
}
