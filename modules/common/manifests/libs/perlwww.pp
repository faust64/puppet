class common::libs::perlwww {
    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
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
