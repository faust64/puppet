class certbot::debian {
    if ($lsbdistcodename == "jessie") {
	if (! defined(Apt::Define::Repo["backports"])) {
	    apt::define::repo {
		"backports":
		    baseurl  => "http://archive.debian.org/debian",
		    branches => "main contrib non-free",
		    codename => "jessie-backports";
	    }
	}

	Apt::Define::Repo["backports"]
	    -> Package["certbot"]
    }

    common::define::package {
	"certbot":
    }

    Common::Define::Package["certbot"]
	-> File["Purge Certbot daily renewal script"]
}
