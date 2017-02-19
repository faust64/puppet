class vmwaremgr {
    include vmwaremgr::vars

    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include vmwaremgr::debian
	}
	default: {
	    common::define::patchneeded { "vmwaremgr": }
	}
    }

    include vmwaremgr::profile
    include vmwaremgr::vspherecli
    include vmwaremgr::munin
}
