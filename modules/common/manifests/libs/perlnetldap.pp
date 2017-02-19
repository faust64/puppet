class common::libs::perlnetldap {
    case $operatingsystem {
	"Debian", "Ubuntu": {
	    $what = "libnet-ldap-perl"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
