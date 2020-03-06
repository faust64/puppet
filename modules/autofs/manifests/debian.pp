class autofs::debian {
    if ($lsbdistcodename == "jessie" or $lsbdistcodename == "wheezy" or $lsbdistcodename == "trusty" or $lsbdistcodename == "stretch" or $lsbdistcodename == "ascii") {
	$pkgname = "autofs5"
    } elsif ($lsbdistcodename == "buster" or $lsbdistcodename == "beowulf") {
	$pkgname = "autofs"
    } else { $pkgname = "autofs4" }

    common::define::package {
	$pkgname:
    }

    Common::Define::Package[$pkgname]
	-> Common::Define::Service["autofs"]
}
