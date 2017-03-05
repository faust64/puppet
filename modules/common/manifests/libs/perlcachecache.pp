class common::libs::perlcachecache {
    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    $what = "libcache-cache-perl"
	}
	"CentOS", "RedHat": {
	    $what = "perl-cache-cache"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
