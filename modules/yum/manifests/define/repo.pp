define yum::define::repo($baseurl    = false,
			 $descr      = $name,
			 $enabled    = 1,
			 $exclude    = false,
			 $failover   = false,
			 $gpgkey     = false,
			 $mirrorlist = false) {
    file {
	"Install $name YUM repository":
	    content => template("yum/repo.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/yum.repos.d/$name.repo",
	    require => File["Prepare YUM for further configuration"];
    }
}
