class common::libs::curlopenssl {
    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    $what = "libcurl4-openssl-dev"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
