class common::libs::perlnetldap {
    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    $what = "libnet-ldap-perl"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
