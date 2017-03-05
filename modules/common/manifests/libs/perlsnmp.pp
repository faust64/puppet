class common::libs::perlsnmp {
    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    $what = "libsnmp-perl"
	}
	"CentOS", "RedHat": {
	    $what = "perl-Net-SNMP"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
