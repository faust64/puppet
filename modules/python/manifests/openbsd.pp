class python::openbsd {
    common::define::package {
	"python":
    }

    if (versioncmp($kernelversion, '5.9') <= 0) {
	file {
	    "Link python bin":
		ensure  => link,
		path    => "/usr/bin/python",
		replace => no,
		require => Common::Define::Package["python"],
		target  => "/usr/local/bin/python2.7";
	}
    } else {
	file {
	    "Link python bin":
		ensure  => link,
		path    => "/usr/bin/python",
		replace => no,
		require => Common::Define::Package["python"],
		target  => "/usr/local/bin/python3.5";
	}
    }
}
