define katello::define::os($archs       = [ "x86_64" ],
			   $ensure      = 'present',
			   $family      = "RedHat",
			   $major       = 7,
			   $mediums     = false,
			   $minor       = 8,
			   $relname     = false,
			   $parts       = [ "Kickstart default" ],
			   $provs       = [ "Kickstart default" ]) {
    if ($ensure == 'present' and $path != false) {
	$archstr     = $archs.join(',')
	$joinedparts = $parts.join(',')
	$joinedprovs = $provs.join(',')

	if ($relname == false) {
	    $addcmd = [ "hammer os create --name '$name'",
			"--family $family --architectures $archstr",
			"--major $major --minor $minor" ]
	} else {
	    $addcmd = [ "hammer os create --name '$name'",
			"--family $family --architectures $archstr",
			"--release-name '$relname'" ]
	}
	$apartcmd = [ "hammer os update --title '$name'",
		      "--partition-tables '$joinedparts'" ]
	$aprovcmd = [ "hammer os update --title '$name'",
		      "--provisioning-templates '$joinedprovs'" ]

	exec {
	    "Install OS $name":
		command     => $addcmd.join(' '),
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer os list'",
		path        => "/usr/bin:/bin",
		require     => File["Install hammer cli configuration"],
		unless      => "hammer os info --title '$name'";
	}

	each($parts) |$ptable| {
	    $cpartcmd = [ "hammer os info --title '$name' | awk ",
			  "'BEG{take=0;}{if (\$0 ~ /Partition tables/){take = 1;}",
			  "else { if (take == 1) { if (\$0 ~ /^ /) { print \$0; }",
			  "else { take = 0; } } } }' | grep '$ptable'" ]
	    exec {
		"Refreshes $name partition tables ($ptable)":
		    command     => $apartcmd.join(' '),
		    environment => [ 'HOME=/root' ],
		    path        => "/usr/bin:/bin",
		    require     =>
			[
			    Class["katello::config::patches"],
			    Exec["Install OS $name"]
			],
		    unless      => $cpartcmd.join(' ');
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
		    require     =>
			[
			    Class["katello::config::patches"],
			    Exec["Install OS $name"]
			],
		    unless      => $cprovcmd.join(' ');
	    }
	}

	if ($mediums != false) {
	    $joinedmeds = $mediums.join(',')
	    each($mediums) |$media| {
		$cmedcmd = [ "hammer os info --title '$name' | awk ",
			     "'BEG{take=0;}{if (\$0 ~ /Installation media/){take = 1;}",
			     "else { if (take == 1) { if (\$0 ~ /^ /) { print \$0; }",
			     "else { take = 0; } } } }' | grep '$media'" ]

		exec {
		    "Refreshes $name installation mediums ($media)":
			command     => "hammer os update --title '$name' --media '$joinmeds'",
			environment => [ 'HOME=/root' ],
			path        => "/usr/bin:/bin",
			require     =>
			    [
				Class["katello::config::patches"],
				Exec["Install Medium $media"],
				Exec["Install OS $name"]
			    ],
			unless      => $cmedcmd.join(' ');
		}
	    }
	}
    } else {
	exec {
	    "Drop OS $name":
		command     => "hammer os delete --title '$name'",
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer os info --title '$name'",
		path        => "/usr/bin:/bin",
		require     => File["Install hammer cli configuration"];
	}
    }
}
