class common::libs::snmp {
    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    $what = "snmp"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
