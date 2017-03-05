class common::libs::exif {
    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    $what = "libimage-exiftool-perl"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
