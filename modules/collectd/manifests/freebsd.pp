class collectd::freebsd {
    case $kernelversion {
	/[1-9][1-9]\./: {
	    $pkgname = "collectd5"
	}
	default: {
	    $pkgname = "collectd"
	}
    }

    common::define::package {
	$pkgname:
    }

    Common::Define::Package[$pkgname]
	-> File["Prepare collectd for further configuration"]
	-> Common::Define::Service["collectd"]
}
