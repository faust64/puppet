class common::libs::perlwww {
    case $operatingsystem {
	"Debian", "Ubuntu": {
	    $what = "libwww-perl"
	}
	"CentOS", "RedHat": {
	    $what = "perl-libwww-perl"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
