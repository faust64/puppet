class python::freebsd {
    if ($python::vars::version == 2) {
	$pkgname = "python27"
    } elsif ($python::vars::version == 3) {
	$pkgname = "python3"
    } else {
	$pkgname = false
    }

    if ($pkgname) {
	common::define::package {
	    $pkgname:
	}
    } else {
	notice {
	    "FIXME: unsupported python version":
	}
    }
}
