class unionfs {
    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include unionfs::debian
	}
	default: {
	    common::define::patchneeded { "unionfs": }
	}
    }

    include unionfs::config
    include unionfs::scripts
}
