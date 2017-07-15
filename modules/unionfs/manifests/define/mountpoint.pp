define unionfs::define::mountpoint($dir   = false,
				   $group = lookup("gid_zero"),
				   $mode  = "01777",
				   $opts  = "defaults",
				   $owner = "root") {
    if ($dir) {
	common::define::mountpoint {
	    $name:
		dev        => "mount_unionfs",
		fmt        => "fuse",
		genericdev => true,
		mount      => $dir,
		opts       => $opts,
		require    => File["Prepare $name runtime directory"];
	}

	file {
	    "Prepare $name read-write directory":
		ensure  => directory,
# mais qu'est-ce que j'vais bien pouvoir te mettre ? ...
#		group   => $group,
#		mode    => "$mode",
#		owner   => $owner,
		group   => lookup("gid_zero"),
		mode    => "01777",
		owner   => root,
		path    => "${dir}_rw",
		require => File["Install mount_unionfs script"];
	    "Prepare $name runtime directory":
		ensure  => directory,
		group   => lookup("gid_zero"),
		mode    => "$mode",
		owner   => root,
		path    => $dir,
		require => Exec["Move $name to read-only directory"];
	}

	exec {
	    "Create $name read-only directory":
		command     => "mkdir -p $dir",
		cwd         => "/",
		path        => "/usr/bin:/bin",
		require     => File["Prepare $name read-write directory"],
		unless      => "test -d $dir -o -d ${dir}_org";
	    "Move $name to read-only directory":
		command     => "mv $dir ${dir}_org",
		cwd         => "/",
		notify      => Exec["Remount $name directory"],
		path        => "/usr/bin:/bin",
		require     => Exec["Create $name read-only directory"],
		unless      => "test -d ${dir}_org";
	    "Remount $name directory":
		command     => "mount $dir",
		cwd         => "/",
		path        => "/usr/bin:/bin",
		refreshonly => true,
		require     => Common::Define::Mountpoint[$name];
	}
    }
    else {
	notify { "Can't define $name unionfs mountpoint: argument missing": }
    }
}
