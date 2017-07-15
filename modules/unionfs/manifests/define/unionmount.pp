define unionfs::define::unionmount($dir  = false,
				   $mode = "1777",
				   $opts = "cow,allow_other") {
# mode:
# seems unionfs sets `1777' by itself
# matching these permissions to avoid non-persistent changes
    if ($dir) {
	common::define::mountpoint {
	    $name:
		dev     => "unionfs-fuse#/tmp=rw:/ro$dir=ro",
		fmt     => "fuse",
		mount   => $dir,
		opts    => $opts,
		require => File["Prepare $name read-write directory"];
	}

	file {
	    "Prepare $name read-write directory":
		ensure  => directory,
		group   => lookup("gid_zero"),
		mode    => $mode,
		owner   => root,
		path    => $dir,
		require => Exec["Move $name to read-only directory"];
	}

	exec {
	    "Move $name to read-only directory":
		command     => "mv $dir ro$dir",
		cwd         => "/",
		notify      => Exec["Remount $name directory"],
		path        => "/usr/bin:/bin",
		require     => File["Prepare read-only directory"],
		unless      => "test -d ro$dir";
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
