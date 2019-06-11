class yum::katello {
    $register_activationkey = lookup("satellite_register_activationkey")
    $register_organization  = lookup("satellite_register_organization")
    $supstream = lookup("satellite_repo")

    exec {
	"Install Katello CA Consumer from Satellite upstream":
	    command => "yum localinstall -y http://$supstream/pub/katello-ca-consumer-latest.noarch.rpm",
	    cwd     => "/",
	    path    => "/usr/sbin:/sbin:/usr/bin:/bin",
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

	each([ "CentOS-Base", "epel" ]) |$repo| {
	    file {
		"Purge $repo - should pull from Satellite upstream":
		    ensure  => absent,
		    path    => "/etc/yum.repos.d/$repo.repo",
		    require => Exec["Register against Katello"];
	    }
	}
    }
}
