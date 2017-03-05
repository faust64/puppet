class common::libs::mediainfo {
    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    $what = "mediainfo"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
