class collectd::openbsd {
    common::define::package {
	$pkgname:
    }

    Common::Define::Package[$pkgname]
	-> File["Prepare collectd for further configuration"]
	-> Common::Define::Service["collectd"]
}
