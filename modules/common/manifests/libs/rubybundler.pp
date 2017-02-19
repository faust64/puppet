class common::libs::rubybundler {
    case $operatingsystem {
	"Debian", "Ubuntu": {
	    $what = "ruby-bundler"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
