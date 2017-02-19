class autofs::debian {
    if ($lsbdistcodename == "jessie" or $lsbdistcodename == "wheezy" or $lsbdistcodename == "trusty") {
	$pkgname = "autofs5"
    } else { $pkgname = "autofs4" }

    common::define::package {
	$pkgname:
    }

    Package[$pkgname]
	-> Service["autofs"]
}
