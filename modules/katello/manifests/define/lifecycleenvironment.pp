define katello::define::lifecycleenvironment($ensure = 'present',
					     $org    = $katello::vars::katello_org,
					     $parent = "Library") {
    if ($ensure == 'present') {
	exec {
	    "Install Lifecycle Environment $name":
		command     => "hammer lifecycle-environment create --name '$name' --organization '$org' --prior '$parent'",
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer lifecycle-environment list --organization '$org'",
		path        => "/usr/bin:/bin",
		unless      => "hammer lifecycle-environment info --name '$name' --organization '$org'";
	}

	if ($parent == 'Library') {
	    File["Install hammer cli configuration"]
		-> Exec["Install Lifecycle Environment $name"]
	} else {
	    Exec["Install Lifecycle Environment $parent"]
		-> Exec["Install Lifecycle Environment $name"]
	}
    } else {
	exec {
	    "Drop Lifecycle Environment $name":
		command     => "hammer lifecycle-environment delete --name '$name' --organization '$org'",
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer lifecycle-environment info --name '$name' --organization '$org'",
		path        => "/usr/bin:/bin",
		require     => File["Install hammer cli configuration"];
	}
    }
}
