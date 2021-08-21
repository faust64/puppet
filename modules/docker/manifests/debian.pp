class docker::debian {
    if ($lsbdistcodename == "jessie" or $lsbdistcodename == "wheezy") {
	if (! defined(Apt::Define::Repo["backports"])) {
	    apt::define::repo {
		"backports":
		    branches => "main contrib non-free",
		    codename => "${lsbdistcodename}-backports";
	    }
	}

	Apt::Define::Repo["backports"]
	    -> Exec["Update APT local cache"]
	    -> Common::Define::Package["docker.io"]
    }

    common::define::package {
	"docker.io":
    }
}
