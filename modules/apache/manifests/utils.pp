class apache::utils {
    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    $pkgname = "apache2-utils"
	}
	"CentOS", "RedHat": {
	    $pkgname = "http-tools"
	}
	default: {
	    $pkgname = false
	}
    }

    if ($pkgname) {
	common::define::package {
	    $pkgname:
	}
    }
}
