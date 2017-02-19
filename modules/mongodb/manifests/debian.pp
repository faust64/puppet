class mongodb::debian {
    if ($lsbdistcodename == "wheezy") {
	apt::define::aptkey {
	    "10gen":
		url => "http://docs.mongodb.org/10gen-gpg-key.asc";
	}

	apt::define::repo {
	    "10gen":
		baseurl  => "http://downloads-distro.mongodb.org/repo/debian-sysvinit",
		branches => "10gen",
		codename => "dist",
		require  => Apt::Define::Aptkey["10gen"];
	}

	Apt::Define::Repo["10gen"]
	    -> Package["mongodb"]
    }

    common::define::package {
	[ "mongodb", "python-pymongo" ]:
    }

    if ($mongodb::vars::do_service) {
	Package["mongodb"]
	    -> Common::Define::Service["mongodb"]
    }

    Package["python-pymongo"]
	-> Class[Mongodb::Munin]
	-> Class[Mongodb::Nagios]
}
