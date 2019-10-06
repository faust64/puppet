class autofs::debian {
    if ($lsbdistcodename == "jessie" or $lsbdistcodename == "wheezy" or $lsbdistcodename == "trusty" or $lsbdistcodename == "stretch" or $lsbdistcodename == "buster") {
	$pkgname = "autofs5"
    } else { $pkgname = "autofs4" }

    common::define::package {
	$pkgname:
    }

    Package[$pkgname]
	-> Service["autofs"]
}
