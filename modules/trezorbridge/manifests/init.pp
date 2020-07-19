class trezorbridge {
    include trezorbridge::vars

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include trezorbridge::debian

	    Class["trezor::debian"]
		-> Class["trezorbridge::github"]
	}
	default: {
	    common::define::patchneeded { "trezor": }
	}
    }

    include common::tools::make
    include trezorbridge::github
    include trezorbridge::user
    include trezorbridge::config

    Class["common::tools::make"]
	-> Class["trezorbridge::github"]
}
