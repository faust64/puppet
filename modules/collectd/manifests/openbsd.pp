class collectd::openbsd {
    common::define::package {
	$pkgname:
    }

    Package[$pkgname]
	-> File["Prepare collectd for further configuration"]
	-> Service["collectd"]
}
