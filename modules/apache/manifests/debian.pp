class apache::debian {
    common::define::package {
	"apache2":
    }

    if ($apache::vars::apache_debugs) {
	common::define::package {
	    "apachetop":
	}
    }

    if ($lsbdistcodename == "wheezy") {
	if (! defined(Apt::Define::Repo["backports"])) {
	    apt::define::repo {
		"backports":
		    branches => "main contrib non-free",
		    codename => "wheezy-backports";
	    }
	}

	Apt::Define::Repo["backports"]
	    -> Package["apache2"]
    }
}
