class unionfs {
    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include unionfs::debian
	}
	default: {
	    common::define::patchneeded { "unionfs": }
	}
    }

    include unionfs::config
    include unionfs::scripts
}
