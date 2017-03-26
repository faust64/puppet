class opennebula::debian {
    $nebula_vers = $opennebula::vars::version

    apt::define::aptkey {
	"opennebula":
	    url => "http://downloads.opennebula.org/repo/$operatingsystem/repo.key";
    }

    if ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan") {
	$baseurl = "repo/$nebula_vers/Debian/$lsbmajdistrelease/"
    } elsif ($operatingsystem == "Ubuntu") {
	$baseurl = "repo/$nebula_vers/Ubuntu/$operatingsystemrelease/"
    } else { $baseurl = "FixMe" }

    apt::define::repo {
	"one":
	    baseurl  => "http://downloads.opennebula.org/$baseurl",
	    branches => "opennebula",
	    codename => "stable",
	    require  => Apt::Define::Aptkey["opennebula"];
    }

    if ($srvtype == "opennebula") {
	Apt::Define::Repo["one"]
	    -> Package["opennebula-node"]
    } else {
	if ($opennebula::vars::do_controller) {
	    Apt::Define::Repo["one"]
		-> Package["opennebula"]

	    if (versioncmp("$nebula_vers", '5.0') <= 0) {
		Package["opennebula"]
		    -> Nfs::Define::Share["OpenNebula"]
	    }
	}
	if ($opennebula::vars::do_oneflow) {
	    Apt::Define::Repo["one"]
		-> Package["opennebula-flow"]
	}
	if ($opennebula::vars::do_onegate) {
	    Apt::Define::Repo["one"]
		-> Package["opennebula-gate"]
	}
	if ($opennebula::vars::do_sunstone) {
	    Apt::Define::Repo["one"]
		-> Package["opennebula-sunstone"]
	}
    }

    common::define::package {
	"opennebula-common":
	    require => Apt::Define::Repo["one"];
    }
}
