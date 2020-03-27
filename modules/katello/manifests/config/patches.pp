class katello::config::patches {
    file {
	"Prepare Katello Patches Directry":
	    ensure => directory,
	    group  => lookup("gid_zero"),
	    mode   => "0755",
	    owner  => "root",
	    path   => "/root/katello-patches";
    }

    each($katello::vars::patches) |$asset| {
	$f = $asset['file']
	$k = $asset['kind']

	file {
	    "Prepare Katello $f Patch":
		group   => lookup("gid_zero"),
		mode    => "0644",
		notify  => Exec["Update Katello Custom $f"],
		owner   => "root",
		path    => "/root/katello-patches/$f.erb",
		require => File["Prepare Katello Patches Directry"],
		source  => "puppet:///modules/katello/$f.erb";
	}

	exec {
	    "Update Katello Custom $f":
		command     => "hammer template update --name 'Custom $f' --file ./$f.erb --type '$k'",
		cwd         => "/root/katello-patches",
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer template info --name 'Custom $f'",
		path        => "/usr/bin:/bin",
		refreshonly => true,
		require     =>
		    [
			File["Install hammer cli configuration"],
			File["Prepare Katello $f Patch"]
		    ];
	    "Install Katello Custom $f":
		command     => "hammer template create --name 'Custom $f' --file ./$f.erb --type '$k'",
		cwd         => "/root/katello-patches",
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer template list",
		path        => "/usr/bin:/bin",
		require     => Exec["Update Katello Custom $f"],
		unless      => "hammer template info --name 'Custom $f'";
	}
    }
}
