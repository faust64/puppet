define katello::define::repositoryset($archi      = "x86_64",
				      $ensure     = 'present',
				      $org        = $katello::vars::katello_org,
				      $releasever = false,
				      $rset       = $name) {
    if ($releasever != false) {
	$rv = " --releasever '$releasever'"
    } else { $rv = "" }
    if ($ensure == 'present') {
	exec {
	    "Enable Repository-Set $name":
		command     => "hammer repository-set enable --name '$rset' --organization '$org'$rv --basearch '$archi'",
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer environment list --organization '$org'",
		path        => "/usr/bin:/bin",
		require     =>
		    [
			Exec["Import Katello Manifest"],
			Katello::Define::Downloadpolicy["main"]
		    ],
		unless      => "hammer repository-set info --name '$name' --organization '$org' | grep -A5 'Enabled Repositories:' | grep -i ID:";
	}
    } else {
	exec {
	    "Disable Repository-Set $name":
		command     => "hammer repository-set disable --name '$rset' --organization '$org'$rv --basearch '$archi'",
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer repository-set info --name '$name' --organization '$org' | grep -A5 'Enabled Repositories:' | grep -i ID:",
		path        => "/usr/bin:/bin",
		require     => Exec["Import Katello Manifest"];
	}
    }
}
