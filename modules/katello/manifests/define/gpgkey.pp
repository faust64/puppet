define katello::define::gpgkey($ensure = 'present',
			       $org    = $katello::vars::katello_org,
			       $source = false) {
    if ($ensure == 'present') {
	if (! defined(File["Prepare Katello GPG temporary directory"])) {
	    file {
		"Prepare Katello GPG temporary directory":
		    ensure => directory,
		    group  => lookup("gid_zero"),
		    mode   => "0700",
		    owner  => "root",
		    path   => "/root/katello-gpg-import";
	    }
	}

	if ($source != false) {
	    common::define::geturl {
		"$name GPG key":
		    require => File["Prepare Katello GPG temporary directory"],
		    target  => "/root/katello-gpg-import/$name.pub",
		    url     => $source,
		    wd      => "/tmp";
	    }

	    exec {
		"Import $name GPG key":
		    command     => "hammer gpg create --name '$name' --key './$name.pub' --organization '$org'",
		    cwd         => "/root/katello-gpg-import",
		    environment => [ 'HOME=/root' ],
		    path        => "/usr/bin:/bin",
		    require     =>
			[
			    Common::Define::Geturl["$name GPG key"],
			    File["Install hammer cli configuration"]
			],
		    unless      => "hammer gpg info --name '$name' --organization '$org'";
	    }
	}
    } else {
	exec {
	    "Drop $name GPG key":
		command     => "hammer gpg delete --name '$name' --organization '$org'",
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer gpg info --name '$name' --organization '$org'",
		path        => "/usr/bin:/bin",
		require     => File["Install hammer cli configuration"];
	}
    }
}
