define katello::define::contentview($composite = false,
				    $content   = [],
				    $dopublish = true,
				    $ensure    = 'present',
				    $org       = $katello::vars::katello_org,
				    $tolce     = []) {
    if ($ensure == 'present') {
	if ($composite != false) {
	    $cargs = ' --composite'
	} else { $cargs = '' }

	exec {
	    "Install Content-View $name":
		command     => "hammer content-view create --name '$name' --organization '$org'$cargs",
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer content-view list --organization '$org'",
		path        => "/usr/bin:/bin",
		require     => File["Install hammer cli configuration"],
		unless      => "hammer content-view info --name '$name' --organization '$org'";
	}

	each($content) |$includes| {
	    if ($composite != false) {
		exec {
		    "Include $includes into Content-View $name":
			command     => "hammer content-view add-version --content-view '$includes' --content-view-version 1.0 --name '$name' --organization '$org'",
			environment => [ 'HOME=/root' ],
			onlyif      => "hammer content-view info --name '$name' --organization '$org'",
			path        => "/usr/bin:/bin",
			require     => Exec["Install Content-View $name"],
			unless      => "hammer content-view info --name '$name' --organization '$org' | grep '$includes'";
		}

		Katello::Define::Contentview[$includes]
		    -> Exec["Include $includes into Content-View $name"]

		if ($dopublish) {
		    Exec["Include $includes into Content-View $name"]
			-> Exec["Publish Content-View $name updated version"]
			-> Exec["Publish Content-View $name"]

		    Exec["Include $includes into Content-View $name"]
			~> Exec["Publish Content-View $name updated version"]
		}
	    } else {
		$pd      = $includes['product']
		$rp      = $includes['repository']
		$rn      = $includes['rname']
		$include = "$pd/$rp"

		exec {
		    "Include $include into Content-View $name":
			command     => "hammer content-view add-repository --product '$pd' --repository '$rp' --name '$name' --organization '$org'",
			environment => [ 'HOME=/root' ],
			onlyif      => "hammer content-view info --name '$name' --organization '$org'",
			path        => "/usr/bin:/bin",
			require     => Exec["Install Content-View $name"],
			unless      => "hammer content-view info --name '$name' --organization '$org' | grep '$rp'";
		}

		Katello::Define::Repository[$rn]
		    -> Exec["Include $include into Content-View $name"]

		if ($dopublish) {
		    Exec["Include $include into Content-View $name"]
			-> Exec["Publish Content-View $name updated version"]
			-> Exec["Publish Content-View $name"]

		    Exec["Include $include into Content-View $name"]
			~> Exec["Publish Content-View $name updated version"]
		}
	    }
	}

	if ($dopublish) {
	    exec {
		"Publish Content-View $name":
		    command     => "hammer content-view publish --name '$name' --organization '$org'",
		    environment => [ 'HOME=/root' ],
		    path        => "/usr/bin:/bin",
		    timeout     => "7200",
		    unless      => "hammer content-view version info --content-view '$name' --organization '$org' --lifecycle-environment Library";
		"Publish Content-View $name updated version":
		    command     => "hammer content-view publish --name '$name' --organization '$org'",
		    environment => [ 'HOME=/root' ],
		    onlyif      => "hammer content-view version info --content-view '$name' --organization '$org' --lifecycle-environment Library",
		    path        => "/usr/bin:/bin",
		    refreshonly => true,
		    timeout     => "7200";
	    }

	    if ($tolce != false) {
		each($tolce) |$promotes| {
		    if ($promotes != "Library") {
			exec {
			    "Promotes Content-View $name to Lifecycle Environment $promotes":
				command     => "hammer content-view version promote --content-view '$name' --version 1.0 --organization '$org' --to-lifecycle-environment '$promotes'",
				environment => [ 'HOME=/root' ],
				path        => "/usr/bin:/bin",
				require     =>
				    [
					Exec["Publish Content-View $name"],
					Katello::Define::Lifecycleenvironment[$promotes]
				    ],
				timeout     => "7200",
				unless      => "hammer content-view info --name '$name' --organization '$org' | grep -E 'Name: $promotes'";
			}
		    }
		}
	    }
	}
    } else {
	exec {
	    "Drop Content-View $name":
		command     => "hammer content-view delete --name '$name' --organization '$org'",
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer content-view info --name '$name' --organization '$org'",
		path        => "/usr/bin:/bin",
		require     => File["Install hammer cli configuration"];
	}
    }
}
