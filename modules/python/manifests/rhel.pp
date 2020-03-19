class python::rhel {
    if ($python::vars::version == 3) {
	$arrayvers = split($operatingsystemrelease, '\.')
	$shortvers = $arrayvers[0]

	file {
	    "Install IUS public GPG key":
		group  => loopup("gid_zero"),
		mode   => "0644",
		owner  => "root",
		path   => "/etc/pki/rpm-gpg/RPM-GPG-KEY-IUS",
		source => "puppet:///modules/yum/ius-release.pub";
	}

	yum::define::repo {
	    "ius":
		baseurl    => "https://repo.ius.io/$shortvers/\$basearch/,
		descr      => "IUS for EL$shortvers - \$basearch",
		gpgkey     => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-IUS",
		require    => File["Install IUS public GPG key"];
	}

	common::define::package {
	    "python36u":
		require => Yum::Define::Repo["ius"];
	}
    } elsif ($pyton::vars::version == 2) {
	common::define::package {
	    "python":
	}
    } else {
	notice {
	    "FIXME: unsupported python version":
	}
    }
}
