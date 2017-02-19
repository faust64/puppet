class common::libs::perlsnmp {
    case $operatingsystem {
	"Debian", "Ubuntu": {
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
