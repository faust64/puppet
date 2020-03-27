define katello::define::domain($ensure = 'present',
			       $loc    = $katello::vars::katello_loc,
			       $org    = $katello::vars::katello_org) {
    if ($ensure == 'present') {
	exec {
	    "Install Domain $name":
		command     => "hammer domain create --name '$name' --organizations '$org' --locations '$loc'",
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer domain list --organization '$org'",
		path        => "/usr/bin:/bin",
		require     => File["Install hammer cli configuration"],
		unless      => "hammer domain info --name '$name' --organization '$org' --location '$loc'";
	}
    } else {
	exec {
	    "Drop Domain $name":
		command     => "hammer domain delete --name '$name' --organization '$org' --location '$loc'",
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer domain info --name '$name' --organization '$org' --location '$loc'",
		path        => "/usr/bin:/bin",
		require     => File["Install hammer cli configuration"];
	}
    }
}
