define yum::define::repo($baseurl    = false,
			 $descr      = $name,
			 $enabled    = 1,
			 $ensure     = "present",
			 $exclude    = false,
			 $failover   = false,
			 $gpgkey     = false,
			 $mirrorlist = false) {
    if ($ensure == "present") {
	file {
	    "$name YUM repository":
		content => template("yum/repo.erb"),
		group   => lookup("gid_zero"),
		mode    => "0644",
		owner   => root,
		path    => "/etc/yum.repos.d/$name.repo",
		require => File["Prepare YUM for further configuration"];
	}
    } else {
	file {
	    "$name YUM repository":
		ensure  => absent,
		path    => "/etc/yum.repos.d/$name.repo",
		require => File["Prepare YUM for further configuration"];
	}
    }
}
