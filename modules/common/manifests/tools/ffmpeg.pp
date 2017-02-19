class common::tools::ffmpeg {
    case $operatingsystem {
	"CentOS", "Debian", "FreeBSD", "OpenBSD", "RedHat", "Ubuntu": {
	    $what = "ffmpeg"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
