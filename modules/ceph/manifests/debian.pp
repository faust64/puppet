class ceph::debian {
    $codename = $ceph::vars::version_codename

    apt::define::aptkey {
	"security@ceph.com":
	    url => "https://git.ceph.com/release.asc";
    }

    apt::define::repo {
	"ceph":
	    baseurl  => "http://download.ceph.com/debian-$codename/",
	    codename => $lsbdistcodename,
	    require  => Apt::Define::Aptkey["security@ceph.com"];
    }
}
