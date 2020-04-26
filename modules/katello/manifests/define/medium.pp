define katello::define::medium($ensure      = 'present',
			       $org         = $katello::vars::katello_org,
			       $path        = false) {
    if ($ensure == 'present' and $path != false) {
	exec {
	    "Install Medium $name":
		command     => "hammer medium create --name '$name' --path '$path' --organization '$org'",
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer medium list --organization '$org'",
		path        => "/usr/bin:/bin",
		require     => File["Install hammer cli configuration"],
		unless      => "hammer medium info --name '$name' --organization '$org'";
	}
    } else {
	exec {
	    "Drop Medium $name":
		command     => "hammer medium delete --name '$name' --organization '$org'",
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer medium info --name '$name' --organization '$org'",
		path        => "/usr/bin:/bin",
		require     => File["Install hammer cli configuration"];
	}
    }
}
