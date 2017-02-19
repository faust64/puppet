class common::libs::rubylog4r {
    case $operatingsystem {
	"Debian", "Ubuntu": {
	    $what = "ruby-log4r"
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
