class wifimgr {
    include wifimgr::vars

    if (! defined(Class["curl"])) {
	include curl
    }
    if (! defined(Class["mongodb"])) {
	include mongodb
    }
    if (! defined(Class["java"])) {
	include java
    }

    case $myoperatingsystem {
	"Debian", "Devuan": {
	    include wifimgr::debian
	}
	default: {
	    common::define::patchneeded { "wifimgr": }
	}
    }

    include wifimgr::service
    include wifimgr::scripts
}
