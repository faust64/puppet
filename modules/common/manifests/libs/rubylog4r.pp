class common::libs::rubylog4r {
    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    $what = "ruby-log4r"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
