class yum::centos {
    $arrayvers = split($operatingsystemrelease, '\.')
    $download  = lookup("download_cmd")
    $supstream = lookup("satellite_repo")
    $shortvers = $arrayvers[0]

    if ($supstream) {
	$register_activationkey = lookup("satellite_register_activationkey")
	$register_organization  = lookup("satellite_register_organization")

	exec {
	    "Install Katello CA Consumer from Satellite upstream":
		command => "yum localinstall -y http://$supstream/pub/katello-ca-consumer-latest.noarch.rpm",
		cwd     => "/",
		path    => "/usr/sbin:/sbin:/usr/bin:/bin",
		require => File["Prepare YUM for further configuration"],
		unless  => "test -s /etc/pki/ca-trust/source/anchors/katello-server-ca.pem";
	}

	if ($satellite_register_organization and $satellite_register_activationkey) {
	    exec {
		"Register against Katello":
		    command => "subscription-manager register --org \"$register_organization\" --activationkey \"$register_activationkey\"",
		    cwd     => "/",
		    path    => "/usr/sbin:/sbin:/usr/bin:/bin",
		    require => Exec["Install Katello CA Consumer from Satellite upstream"],
		    unless  => "test -s /etc/yum.repos.d/redhat.repo";
	    }
	}

	each([ "CentOS-Base", "epel" ]) |$repo| {
	    file {
		"Purge $repo - should pull from Satellite upstream":
		    ensure  => absent,
		    path    => "/etc/yum.repos.d/$repo.repo",
		    require => Exec["Install Katello CA Consumer from Satellite upstream"];
	    }
	}
    } else {
	file {
	    "Install CentOS Base repository":
		content => template("yum/centos-base.erb"),
		group   => lookup("gid_zero"),
		mode    => "0644",
		owner   => root,
		path    => "/etc/yum.repos.d/CentOS-Base.repo",
		require => File["Prepare YUM for further configuration"];
	}

	exec {
	    "Download EPEL repository key":
		command => "$download https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-$shortvers",
		cwd     => "/etc/pki/rpm-gpg",
		path    => "/usr/bin:/bin",
		unless  => "test -s RPM-GPG-KEY-EPEL-$shortvers";
	}

	yum::define::repo {
	    "epel":
		descr      => "EPEL - \$basearch",
		failover   => "priority",
		gpgkey     => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-$shortvers",
		mirrorlist => "https://mirrors.fedoraproject.org/metalink?repo=epel-$shortvers&arch=\$basearch",
		require    => Exec["Download EPEL repository key"];
	}
    }
}
