define katello::define::os($archs       = [ "x86_64" ],
			   $ensure      = 'present',
			   $family      = "RedHat",
			   $major       = 7,
			   $mediums     = false,
			   $minor       = 8,
			   $relname     = false,
			   $org         = $katello::vars::katello_org,
			   $parts       = [ "Kickstart default" ],
			   $provs       = [ "Kickstart default" ]) {
    if ($ensure == 'present' and $path != false) {
	$archstr     = $archs.join(',')
	$joinedparts = $parts.join(',')
	$joinedprovs = $provs.join(',')

	if ($relname == false) {
	    $addcmd = [ "hammer os create --name '$name' --organization '$org'",
			"--family $family --architectures $archstr",
			"--major $major --minor $minor" ]
	} else {
	    $addcmd = [ "hammer os create --name '$name' --organization '$org'",
			"--family $family --architectures $archstr",
			"--release-name '$relname'" ]
	}
	$apartcmd = [ "hammer os update --title '$name' --organization '$org'",
		      "--partition-tables '$joinedparts'" ]
	$aprovcmd = [ "hammer os update --title '$name' --organization '$org'",
		      "--provisioning-templates '$joinedprovs'" ]

	exec {
	    "Install OS $name":
		command     => $addcmd.join(' '),
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer os list --organization '$org'",
		path        => "/usr/bin:/bin",
		require     => File["Install hammer cli configuration"],
		unless      => "hammer os info --title '$name' --organization '$org'";
	}

	each($parts) |$ptable| {
	    $cpartcmd = [ "hammer os info --title '$name' | awk ",
			  "'BEG{take=0;}{if (\$0 ~ /Partition tables/){take = 1;}",
			  "else { if (take == 1) { if (\$0 ~ /^ /) { print \$0; }",
			  "else { take = 0; } } } }' | grep '$ptable'" ]
	    exec {
		"Refreshes $name partition tables ($ptable)":
		    command     => $aprovcmd.join(' '),
		    environment => [ 'HOME=/root' ],
		    path        => "/usr/bin:/bin",
		    require     => Exec["Install OS $name"],
		    unless      => $cprovcmd.join(' ');
	    }
	}

	each($provs) |$ptplate| {
	    $cprovcmd = [ "hammer os info --title '$name' | awk ",
			  "'BEG{take=0;}{if (\$0 ~ /Templates/){take = 1;}",
			  "else { if (take == 1) { if (\$0 ~ /^ /) { print \$0; }",
			  "else { take = 0; } } } }' | grep '$ptplate'" ]
	    exec {
		"Refreshes $name provisioning templates ($ptplate)":
		    command     => $aprovcmd.join(' '),
		    environment => [ 'HOME=/root' ],
		    path        => "/usr/bin:/bin",
		    require     => Exec["Install OS $name"],
		    unless      => $cprovcmd.join(' ');
	    }
	}

	if ($mediums != false) {
	    $joinedmeds = $mediums.join(',')
	    $amedcmd    = [ "hammer os update --title '$name' --organization '$org'",
			    "--media '$joinmeds'" ]

	    each($mediums) |$media| {
		$cmedcmd = [ "hammer os info --title '$name' | awk ",
			     "'BEG{take=0;}{if (\$0 ~ /Installation media/){take = 1;}",
			     "else { if (take == 1) { if (\$0 ~ /^ /) { print \$0; }",
			     "else { take = 0; } } } }' | grep '$media'" ]

		exec {
		    "Refreshes $name installation mediums ($media)":
			command     => $amedcmd.join(' '),
			environment => [ 'HOME=/root' ],
			path        => "/usr/bin:/bin",
			require     => Exec["Install OS $name"],
			unless      => $cmedcmd.join(' ');
		}

		if (defined(Katello::define::medium[$name])) {
		    Katello::define::medium[$name]
			-> Exec["Refreshes $name installation mediums ($media)"]
		}
	    }
	}
    } else {
	exec {
	    "Drop OS $name":
		command     => "hammer os delete --title '$name' --organization '$org'",
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer os info --title '$name' --organization '$org'",
		path        => "/usr/bin:/bin",
		require     => File["Install hammer cli configuration"];
	}
    }
}
