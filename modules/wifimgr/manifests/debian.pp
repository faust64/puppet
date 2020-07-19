class wifimgr::debian {
    apt::define::aptkey {
	"UniFi":
	    keyid   => "C0A52C50",
	    require =>
		[
		    Class["java"],
		    Class["curl"],
		    Class["mongodb"]
		];
    }

    apt::define::repo {
	"Ubiquiti":
	    baseurl  => "http://www.ubnt.com/downloads/unifi/debian",
	    codename => "stable",
	    branches => "ubiquiti",
	    require  => Apt::Define::Aptkey["UniFi"];
    }

    common::define::package {
	"unifi":
	    require =>
		[
		    Apt::Define::Repo["Ubiquiti"],
		    Exec["Update APT local cache"]
		];
    }

    Package["unifi"]
	-> Common::Define::Service["unifi"]
}
