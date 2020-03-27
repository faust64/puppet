define katello::define::syncplan($description = $name,
				 $ensure      = 'present',
				 $interval    = 'daily',
				 $org         = $katello::vars::katello_org,
				 $syncdate    = "\$(date --date tomorrow +%Y-%m-%d)") {
    if ($ensure == 'present') {
	exec {
	    "Install Sync Plan $name":
		command     => "hammer sync-plan create --name '$name' --organization '$org' --interval '$interval' --description '$description' --enabled yes --sync-date $syncdate",
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer sync-plan list --organization '$org'",
		path        => "/usr/bin:/bin",
		require     => File["Install hammer cli configuration"],
		unless      => "hammer sync-plan info --name '$name' --organization '$org'";
	    "Update Sync Plan $name Status":
		command     => "hammer sync-plan update --name '$name' --organization '$org' --enabled yes",
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer sync-plan info --name '$name' --organization '$org'",
		path        => "/usr/bin:/bin",
		require     => Exec["Install Sync Plan $name"],
		unless      => "hammer sync-plan info --name '$name' --organization '$org' | grep -E 'Enabled:.*yes'";
	    "Update Sync Plan $name Interval":
		command     => "hammer sync-plan update --name '$name' --organization '$org' --interval '$interval'",
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer sync-plan info --name '$name' --organization '$org'",
		path        => "/usr/bin:/bin",
		require     => Exec["Install Sync Plan $name"],
		unless      => "hammer sync-plan info --name '$name' --organization '$org' | grep -E 'Interval:.*$interval'";
	}
    } else {
	exec {
	    "Drop Sync Plan $name":
		command     => "hammer sync-plan delete --name '$name' --organization '$org'",
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer sync-plan info --name '$name' --organization '$org'",
		path        => "/usr/bin:/bin",
		require     => File["Install hammer cli configuration"];
	}
    }
}
