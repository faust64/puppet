class common::tools::ffmpeg {
    case $myoperatingsystem {
	"CentOS", "Debian", "Devuan", "FreeBSD", "OpenBSD", "RedHat", "Ubuntu": {
	    $what = "ffmpeg"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
