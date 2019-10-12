class autofs::debian {
    if ($lsbdistcodename == "jessie" or $lsbdistcodename == "wheezy" or $lsbdistcodename == "trusty" or $lsbdistcodename == "stretch" or $lsbdistcodename == "ascii" or $lsbdistcodename == "buster" or $lsbdistcodename == "beowulf") {
	$pkgname = "autofs5"
    } else { $pkgname = "autofs4" }

    common::define::package {
	$pkgname:
    }

    Package[$pkgname]
	-> Service["autofs"]
}
