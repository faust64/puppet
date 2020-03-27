define katello::define::hostcollection($ensure = 'present',
				       $limit  = false,
				       $org    = $katello::vars::katello_org) {
    if ($ensure == 'present') {
	if ($limit != false) {
	    $hostlimit = " --max-hosts $limit"
	} else {
	    $hostlimit = " --unlimited-hosts yes"
	}

	exec {
	    "Install Host-Collection $name":
		command     => "hammer host-collection create --name '$name' --organization '$org'$hostlimit",
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer host-collection list --organization '$org'",
		path        => "/usr/bin:/bin",
		require     => File["Install hammer cli configuration"],
		unless      => "hammer host-collection info --name '$name' --organization '$org'";
	}
    } else {
	exec {
	    "Drop Host-Collection $name":
		command     => "hammer host-collection delete --name '$name' --organization '$org'",
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer host-collection info --name '$name' --organization '$org'",
		path        => "/usr/bin:/bin",
		require     => File["Install hammer cli configuration"];
	}
    }
}
