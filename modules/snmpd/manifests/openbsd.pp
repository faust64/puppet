class snmpd::openbsd {
    file_line {
	"Enable snmpd on boot":
	    line => "snmpd_flags=",
	    path => "/etc/rc.conf.local";
    }

    File_line["Enable snmpd on boot"]
	-> Service["snmpd"]
}
