class common::libs::snmp {
    case $operatingsystem {
	"Debian", "Ubuntu": {
	    $what = "snmp"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
