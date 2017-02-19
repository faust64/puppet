class common::libs::exif {
    case $operatingsystem {
	"Debian", "Ubuntu": {
	    $what = "libimage-exiftool-perl"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
