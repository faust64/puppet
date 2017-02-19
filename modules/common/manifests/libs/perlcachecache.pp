class common::libs::perlcachecache {
    case $operatingsystem {
	"Debian", "Ubuntu": {
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
