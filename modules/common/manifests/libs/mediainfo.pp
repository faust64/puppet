class common::libs::mediainfo {
    case $operatingsystem {
	"Debian", "Ubuntu": {
	    $what = "mediainfo"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
