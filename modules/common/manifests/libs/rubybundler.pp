class common::libs::rubybundler {
    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    $what = "ruby-bundler"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
