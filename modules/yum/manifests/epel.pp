class yum::epel {
    $shortvers = $operatingsystemmajrelease

    common::define::geturl {
	"EPEL repository key":
	    nomv   => true,
	    target => "/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-$shortvers",
	    url    => "https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-$shortvers",
	    wd     => "/etc/pki/rpm-gpg";
    }

    yum::define::repo {
	"epel":
	    descr      => "EPEL - \$basearch",
	    failover   => "priority",
	    gpgkey     => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-$shortvers",
	    mirrorlist => "https://mirrors.fedoraproject.org/metalink?repo=epel-$shortvers&arch=\$basearch",
	    require    => Common::Define::Geturl["EPEL repository key"];
    }

    if ($operatingsystemmajrelease == "8" or $operatingsystemmajrelease == 8) {
	yum::define::repo {
	    "epel-modular":
		descr      => "EPEL Modular - \$basearch",
		failover   => "priority",
		gpgkey     => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-$shortvers",
		mirrorlist => "https://mirrors.fedoraproject.org/metalink?repo=epel-modular-\$releasever&arch=\$basearch&infra=\$infra&content=\$contentdir",
		require    => Common::Define::Geturl["EPEL repository key"];
	}
    }
}
