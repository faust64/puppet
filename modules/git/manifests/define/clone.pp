define git::define::clone($branch          = "master",
			  $git_password    = false,
			  $git_username    = false,
			  $local_container = false,
			  $local_name      = $name,
			  $repository      = false,
			  $submoduleinit   = false,
			  $update          = false) {
    if ($repository and $local_container) {
	if (! defined(Class[git])) {
	    include git
	}
	if ($git_username and $git_password) {
	    $realrepo = "FIXME"
	} else {
	    $realrepo = $repository
	}

	if ($submoduleinit) {
	    exec {
		"GIT clone $name":
		    command => "git clone -b $branch $realrepo $local_name",
		    creates => "$local_container/$local_name",
		    cwd     => $local_container,
		    notify  => Exec["GIT init submodule $name"],
		    path    => "/usr/local/bin:/usr/bin:/bin",
		    require => Package["git"];
	    }
	} else {
	    exec {
		"GIT clone $name":
		    command => "git clone -b $branch $realrepo $local_name",
		    creates => "$local_container/$local_name",
		    cwd     => $local_container,
		    path    => "/usr/local/bin:/usr/bin:/bin",
		    require => Package["git"];
	    }
	}

	if ($update) {
	    if ($submoduleinit) {
		exec {
		    "GIT update $name":
			command => "git pull",
			cwd     => "$local_container/$local_name",
			notify  => Exec["GIT init submodule $name"],
			unless  => "git fetch -v --dry-run 2>&1 | grep $branch | grep 'up to date'",
			path    => "/usr/local/bin:/usr/bin:/bin",
			require => Exec["GIT clone $name"];
		}
	    } else {
		exec {
		    "GIT update $name":
			command => "git pull",
			cwd     => "$local_container/$local_name",
			unless  => "git fetch -v --dry-run 2>&1 | grep $branch | grep 'up to date'",
			path    => "/usr/local/bin:/usr/bin:/bin",
			require => Exec["GIT clone $name"];
		}
	    }
	}
	if ($submoduleinit) {
	    exec {
		"GIT init submodule $name":
		    command     => "git submodule update --recursive --init",
		    cwd         => "$local_container/$local_name",
		    path        => "/usr/local/bin:/usr/bin:/bin",
		    refreshonly => true,
		    require     => Exec["GIT clone $name"];
	    }
	}
    } elsif ($repository) {
	notify{ "GIT clone $name missing local container": }
    } else {
	notify{ "GIT clone $name missing local repository": }
    }
}
