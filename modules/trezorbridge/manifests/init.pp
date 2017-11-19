class trezorbridge {
    include trezorbridge::vars

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include trezorbridge::debian

	    Class[Trezor::Debian]
		-> Class[Trezorbridge::Github]
	}
	default: {
	    common::define::patchneeded { "trezor": }
	}
    }

    include common::tools::make
    include trezorbridge::github
    include trezorbridge::user
    include trezorbridge::config

    Class[Common::Tools::Make]
	-> Class[Trezorbridge::Github]
}
