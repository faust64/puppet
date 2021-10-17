define katello::define::scapcontent($ensure = "present",
				    $loc    = $katello::vars::katello_loc,
				    $org    = $katello::vars::katello_org,
				    $src    = "sg-rhel8-ds-1.2.xml") {
    if ($ensure == 'present') {
	file {
	    "Installs SCAP Content $name Source":
		group   => lookup("gid_zero"),
		mode    => "0644",
		owner   => "root",
		path    => "/usr/src/$src",
		source  => "puppet:///modules/katello/$src";
	}

	$createcmd = [ "hammer scap-content create --location '$loc'",
			"--organization '$org' --original-filename $src",
			"--scap-file /usr/src/$src --title '$name'" ]

	exec {
	    "Loads SCAP Content $name":
		command     => $createcmd.join(' '),
		environment => [ 'HOME=/root' ],
		path        => "/usr/bin:/bin",
		require     => [
			File["Install hammer cli configuration"],
			File["Installs SCAP Content $name Source"]
		    ],
		unless      => "hammer scap-content list | grep '$name'";
	}
    } else {
	$deletecmd = [ "hammer scap-content delete --location '$loc'",
			"--organization '$org' --title '$name'" ]

	exec {
	    "Purges SCAP Content $name":
		command     => $deletecmd.join(' '),
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer scap-content list | grep '$name'",
		path        => "/usr/bin:/bin",
		require     => [
			File["Install hammer cli configuration"],
			File["Installs SCAP Content $name Source"]
		    ];
	}
    }
}
