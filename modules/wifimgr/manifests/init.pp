class wifimgr {
    include wifimgr::vars

    if (! defined(Class[Curl])) {
	include curl
    }
    if (! defined(Class[Mongodb])) {
	include mongodb
    }
    if (! defined(Class[Java])) {
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
    include wifimgr::profile

    if ($wifimgr::vars::dumpdir) {
	include wifimgr::backups
    }
}
