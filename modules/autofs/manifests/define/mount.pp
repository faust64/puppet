define autofs::define::mount($fsopts      = "ro",
			     $mountpoint  = "/media/$name",
			     $mountstatus = "enabled",
			     $remotepoint = false) {
    if (! defined(Class["autofs"]) and $mountstatus == "enabled") {
	include autofs
    } elsif (! defined(Class["autofs"])) {
	include autofs::vars
    }

    if ($fsopts =~ /fstype=nfs/) {
	if ($operatingsystem == "CentOS" or $operatingsystem == "RedHat") {
	    include nfs::clientrhel
	}
    }

    $conf_dir = $autofs::vars::conf_dir
    $no_dir   = $autofs::vars::no_dir

    if ($remotepoint and $mountstatus == "enabled") {
	exec {
	    "Create local mountpoint $mountpoint":
		command => "mkdir -p $mountpoint",
		cwd     => "/",
		path    => "/usr/bin:/bin",
		unless  => "test -d $mountpoint",
		require => File["Install autofs $name mount definition"];
	}

	file {
	    "Install autofs $name mount definition":
		content => template("autofs/mount.erb"),
		group   => hiera("gid_zero"),
		mode    => "0644",
		notify  => Service["autofs"],
		owner   => root,
		path    => "$conf_dir/$name",
		require => File["Prepare autofs for further configuration"];
	}

	if ($no_dir == true) {
	    file_line {
		"Declare autofs $name mount invokation":
		    line    => "$mountpoint/ $conf_dir/$name --ghost --timeout 43200",
		    match   => "$mountpoint/ ",
		    notify  => Service["autofs"],
		    path    => "/etc/auto.master";
	    }
	} else {
	    file {
		"Install autofs $name mount invokation":
		    content => template("autofs/call.erb"),
		    group   => hiera("gid_zero"),
		    mode    => "0644",
		    notify  => Service["autofs"],
		    owner   => root,
		    path    => "$conf_dir/$name.autofs",
		    require => Exec["Create local mountpoint $mountpoint"];
	    }
	}
    } elsif ($mountstatus != "enabled") {
	if ($no_dir == true) {
	    if (defined(Service["autofs"])) {
		file_line {
		    "Drop autofs $name mount invokation":
			ensure  => absent,
			line    => "$mountpoint/ $conf_dir/$name --ghost --timeout 43200",
			notify  => Service["autofs"],
			path    => "/etc/auto.master";
		}

		file {
		    "Drop autofs $name mount definition":
			ensure  => absent,
			force   => true,
			notify  => Service["autofs"],
			path    => "$conf_dir/$name",
			require => File_line["Drop autofs $name mount invokation"];
		}
	    } else {
		file_line {
		    "Drop autofs $name mount invokation":
			ensure  => absent,
			line    => "$mountpoint/ $conf_dir/$name --ghost --timeout 43200",
			path    => "/etc/auto.master";
		}

		file {
		    "Drop autofs $name mount definition":
			ensure  => absent,
			force   => true,
			path    => "$conf_dir/$name",
			require => File_line["Drop autofs $name mount invokation"];
		}
	    }
	} elsif (defined(Service["autofs"])) {
	    file {
		"Drop autofs $name mount definition":
		    ensure  => absent,
		    force   => true,
		    notify  => Service["autofs"],
		    path    => "$conf_dir/$name";
		"Drop autofs $name mount invokation":
		    ensure  => absent,
		    force   => true,
		    notify  => Service["autofs"],
		    path    => "$conf_dir/$name.autofs",
		    require => File["Drop autofs $name mount definition"];
	    }
	} else {
	    file {
		"Drop autofs $name mount definition":
		    ensure  => absent,
		    force   => true,
		    path    => "$conf_dir/$name";
		"Drop autofs $name mount invokation":
		    ensure  => absent,
		    force   => true,
		    path    => "$conf_dir/$name.autofs",
		    require => File["Drop autofs $name mount definition"];
	    }
	}
    }
}
