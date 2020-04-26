define katello::define::product($description = $name,
				$ensure      = 'present',
				$syncplan    = false,
				$org         = $katello::vars::katello_org) {
    if ($ensure == 'present') {
	if ($syncplan != "" and $syncplan != false) {
	    Katello::Define::Syncplan[$syncplan]
		-> Exec["Install Product $name"]

	    $addcmd  = "hammer product create --name '$name' --organization '$org' --description '$description' --sync-plan '$syncplan'"
	    $pupdcmd = "hammer product update --name '$name' --organization '$org' --sync-plan '$syncplan'"
	} else {
	    $addcmd  = "hammer product create --name '$name' --organization '$org' --description '$description'"
	    $pupdcmd = false
	}

	exec {
	    "Install Product $name":
		command     => $addcmd,
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer product list --organization '$org'",
		path        => "/usr/bin:/bin",
		require     => File["Install hammer cli configuration"],
		unless      => "hammer product info --name '$name' --organization '$org'";
	}

	if ($pupdcmd) {
	    exec {
		"Update Product $name Sync Plan":
		    command     => $pupdcmd,
		    environment => [ 'HOME=/root' ],
		    onlyif      => "hammer product list --organization '$org'",
		    path        => "/usr/bin:/bin",
		    require     => Exec["Install Product $name"],
		    unless      => "hammer sync-plan info --id \$(hammer product info --name '$name' --organization '$org' | awk '/Sync Plan ID:/{print \$4;exit 0;}') --organization '$org' | grep '$syncplan'";
	    }
	}
    } else {
	exec {
	    "Drop Product $name":
		command     => "hammer product delete --name '$name' --organization '$org'",
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer product info --name '$name' --organization '$org'",
		path        => "/usr/bin:/bin",
		require     => File["Install hammer cli configuration"];
	}
    }
}
