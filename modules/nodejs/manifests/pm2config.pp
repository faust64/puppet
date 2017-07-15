class nodejs::pm2config {
    if ($nodejs::vars::pm2_group != lookup("gid_zero")) {
	if (! defined(Group[$nodejs::vars::pm2_group])) {
	    group {
		$nodejs::vars::pm2_group:
		    ensure => present;
	    }
	}
    }

    if ($nodejs::vars::pm2_user != "root") {
	if (! defined(User[$nodejs::vars::pm2_user])) {
	    user {
		$nodejs::vars::pm2_user:
		    gid  => $nodejs::vars::pm2_group,
		    home => $nodejs::vars::pm2_home;
	    }

	    if (defined(Group[$nodejs::vars::pm2_group])) {
		Group[$nodejs::vars::pm2_group]
		    -> User[$nodejs::vars::pm2_user]
	    }
	}
    }

    if ($nodejs::vars::pm2_home != "/root") {
	if (! defined(File[$nodejs::vars::pm2_home])) {
	    file {
		"Install pm2 home directory":
		    ensure => directory,
		    group  => $nodejs::vars::pm2_group,
		    mode   => "0750",
		    owner  => $nodejs::vars::pm2_user,
		    path   => $nodejs::vars::pm2_home;
	    }

	    if (defined(User[$nodejs::vars::pm2_user])) {
		User[$nodejs::vars::pm2_user]
		    -> File["Install pm2 home directory"]
	    } elsif (defined(Group[$nodejs::vars::pm2_group])) {
		Group[$nodejs::vars::pm2_group]
		    -> File["Install pm2 home directory"]
	    }
	}
    }
}
