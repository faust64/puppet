define katello::define::environment($ensure = 'present',
				    $loc    = $katello::vars::katello_loc,
				    $org    = $katello::vars::katello_org) {
    if ($ensure == 'present') {
	exec {
	    "Install Environment $name":
		command     => "hammer environment create --name '$name' --organization '$org' --location '$loc'",
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer environment list --organization '$org'",
		path        => "/usr/bin:/bin",
		require     => File["Install hammer cli configuration"],
		unless      => "hammer environment info --name '$name' --organization '$org' --location '$loc'";
	}
    } else {
	exec {
	    "Drop Environment $name":
		command     => "hammer environment delete --name '$name' --organization '$org' --location '$loc'",
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer environment info --name '$name' --organization '$org' --location '$loc'",
		path        => "/usr/bin:/bin",
		require     => File["Install hammer cli configuration"];
	}
    }
}
