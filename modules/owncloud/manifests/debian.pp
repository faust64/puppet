class owncloud::debian {
    if ($lsbdistcodename == "wheezy" or $lsbdistcodename == "jessie") {
	$repopath = "http://download.opensuse.org/repositories/isv:ownCloud:community/Debian_$lsbmajdistrelease.0/"
    } elsif ($lsbdistcodename == "stretch") {
	$repopath = "http://download.owncloud.org/download/repositories/stable/Debian_$lsbmajdistrelease.0/"
    } elsif ($lsbdistcodename == "buster" or $lsbdistcodename == "bullseye") {
	$repopath = "http://download.owncloud.org/download/repositories/stable/Debian_$lsbmajdistrelease/"
    } elsif ($lsbdistcodename == "xenial" or $lsbdistcodename == "trusty") {
	$repopath = "http://download.owncloud.org/download/repositories/stable/Ubuntu_$operatingsystemrelease/"
    }
    if ($repopath) {
	apt::define::aptkey {
	    "ownCloud":
		url => "$repopath/Release.key";
	}

	apt::define::repo {
	    "owncloud":
		baseurl  => $repopath,
		branches => "",
		codename => "/",
		require  => Apt::Define::Aptkey["ownCloud"];
	}

	Apt::Define::Repo["owncloud"]
	    -> Common::Define::Package["owncloud"]
    }

    common::define::package {
	"owncloud":
    }

    Package["owncloud"]
	-> File["Prepare owncloud for further configuration"]
}
