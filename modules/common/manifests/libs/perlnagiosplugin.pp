class common::libs::perlnagiosplugin {
    case $operatingsystem {
	"Debian", "Ubuntu": {
	    $what = "libnagios-plugin-perl"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
