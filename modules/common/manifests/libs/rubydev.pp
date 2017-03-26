class common::libs::rubydev {
    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    $what = "ruby-dev"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
