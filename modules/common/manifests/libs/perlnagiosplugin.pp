class common::libs::perlnagiosplugin {
    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    $what = "libnagios-plugin-perl"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
