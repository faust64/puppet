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

    if ($opennebula::vars::nebula_class == "compute") {
	Apt::Define::Repo["one"]
	    -> Package["opennebula-node"]
    } else {
	Apt::Define::Repo["one"]
	    -> Package["opennebula-sunstone"]
	    -> Nfs::Define::Share["OpenNebula"]
    }
}
