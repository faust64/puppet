define nodejs::define::app($appdeps       = false,
			   $appgit        = false,
			   $appsrc        = false,
			   $appsvn        = false,
			   $apptar        = false,
			   $appstatus     = "enabled",
			   $dobower       = false,
			   $submoduleinit = false,
			   $startfork     = 2,
			   $startwith     = "./app.js",
			   $startwithargs = false,
			   $update        = false) {
    if ($nodejs::vars::force_version) {
	$nodepath = "/usr/local/nodejs/lib/node_modules/pm2/bin"
    } else {
	$nodepath = "/usr/local/lib/node_modules/pm2/bin"
    }
    if ($appsrc or $appgit or $appsvn or $apptar) {
	if ($nodejs::vars::service_name == "pm2") {
	    $installpath = "/usr/share"
	    $pm2home     = $nodejs::vars::pm2_home

	    if (! defined(Exec["Save pm2 processes"])) {
		exec {
		    "Save pm2 processes":
			command     => "pm2 save",
			cwd         => "/",
			environment => [ "PM2_HOME=$pm2home/.pm2" ],
			path        => "${nodepath}:/usr/local/bin:/usr/bin:/bin",
			refreshonly => true;
		}
	    }
	} else {
	    $installpath = "/etc/node/apps-available"
	}

	if ($appstatus == "enabled") {
	    if ($nodejs::vars::service_name != "pm2") {
		$do_notify = Service["nodejs"]
	    } else {
		$do_notify = Exec["Reload $name nodejs application"]
	    }
	    if ($appsrc) {
		file {
		    "Install $name nodejs application":
			group   => lookup("gid_zero"),
			ignore  => [ ".svn", ".git" ],
			notify  => $do_notify,
			owner   => root,
			recurse => true,
			path    => "$installpath/$name",
			source  => "puppet:///modules/$appsrc";
		}

		if ($nodejs::vars::service_name != "pm2") {
		    File["Prepare node apps-available directory"]
			-> File["Install $name nodejs application"]
		    File["Prepare node apps-enabled directory"]
			-> File["Install $name nodejs application"]
		}
	    } elsif ($appgit) {
		if ($submoduleinit) {
		    git::define::clone {
			$name:
			    local_container => $installpath,
			    local_name      => $name,
			    notify          => $do_notify,
			    repository      => $appgit,
			    submoduleinit   => true,
			    update          => $update;
		    }
		} else {
		    git::define::clone {
			$name:
			    local_container => $installpath,
			    local_name      => $name,
			    notify          => $do_notify,
			    repository      => $appgit,
			    update          => $update;
		    }
		}
	    } elsif ($appsvn) {
		subversion::define::workdir {
		    $name:
			local_container => $installpath,
			local_name      => $name,
			notify          => $do_notify,
			repository      => $appsvn,
			update          => $update;
		}
	    } else {
		#FIXME apptar
	    }

	    if ($appdeps != false) {
		each($appdeps) |$dep| {
		    nodejs::define::module { $dep: app => $name; }

		    if ($appsrc) {
			File["Install $name nodejs application"]
			    -> Nodejs::Define::Module[$dep]
		    } elsif ($appgit) {
			Git::Define::Clone[$name]
			    -> Nodejs::Define::Module[$dep]
		    } elsif ($appsvn) {
			Subversion::Define::Workdir[$name]
			    -> Nodejs::Define::Module[$dep]
		    } else {
			#FIXME apptar
		    }
		    if ($nodejs::vars::service_name != "pm2") {
			Nodejs::Define::Module[$dep]
			    -> File["Enable $name nodejs application"]
		    } else {
			Nodejs::Define::Module[$dep]
			    -> Exec["Reload $name nodejs application"]
			    -> Exec["Start $name nodejs application"]
		    }
		}
	    } else {
		exec {
		    "Install $name nodejs application":
			command => "npm install",
			cwd     => "$installpath/$name",
			onlyif  => "test -s package.json",
			path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
			unless  => "test -d node_modules";
		}

		if ($dobower) {
		    if (($nodejs::vars::service_name == "pm2" and $nodejs::vars::pm2_user == "root") or $nodejs::vars::service_name != "pm2") {
			exec {
			    "Install $name Bower dependencies":
				command     => "bower install --allow-root",
				cwd         => "$installpath/$name",
				onlyif      => "test -s bower.json",
				path        => "/usr/local/bin:/usr/bin:/bin",
				require     => Exec["Install $name nodejs application"],
				unless      => "test -d $installpath/$name/app/bower_components";
			}
		    } else {
			$pm2home = $nodejs::vars::pm2_user

#FIXME: should at least create target folder with proper permissions
			exec {
			    "Install $name Bower dependencies":
				command     => "bower install",
				cwd         => "$installpath/$name",
				environment => [ "HOME=$pm2home" ],
				onlyif      => "test -s bower.json",
				path        => "/usr/local/bin:/usr/bin:/bin",
				require     => Exec["Install $name nodejs application"],
				unless      => "test -d $installpath/$name/app/bower_components",
				user        => $nodejs::vars::pm2_user;
			}
		    }
		}

		if ($appsrc) {
		    File["Install $name nodejs application"]
			-> Exec["Install $name nodejs application"]
		} elsif ($appgit) {
		    Git::Define::Clone[$name]
			-> Exec["Install $name nodejs application"]
		} elsif ($appsvn) {
		    Subversion::Define::Workdir[$name]
			-> Exec["Install $name nodejs application"]
		} else {
		    #FIXME apptar
		}
		if ($nodejs::vars::service_name != "pm2") {
		    Exec["Install $name nodejs application"]
			-> File["Enable $name nodejs application"]
		} else {
		    Exec["Install $name nodejs application"]
			-> Exec["Reload $name nodejs application"]
			-> Exec["Start $name nodejs application"]
		}
	    }

	    if ($nodejs::vars::service_name != "pm2") {
		file {
		    "Enable $name nodejs application":
			ensure  => link,
			notify  => Service["nodejs"],
			path    => "/etc/node/apps-enabled/$name",
			target  => "$installpath/$name";
		}
	    } else {
		exec {
		    "Reload $name nodejs application":
			command     => "pm2 gracefulReload $name",
			cwd         => "$installpath/$name",
			environment => [ "PM2_HOME=$pm2home/.pm2" ],
			refreshonly => true,
			onlyif      => "pm2 show $name",
			path        => "${nodepath}:/usr/local/bin:/usr/bin:/bin";
		}

		if ($startwithargs) {
		    exec {
			"Start $name nodejs application":
			    command     => "pm2 start $startwith --name $name -i $startfork --output /var/log/nodejs/$name.log --error /var/log/nodejs/$name.err -- $startwithargs",
			    cwd         => "$installpath/$name",
			    environment => [ "PM2_HOME=$pm2home/.pm2" ],
			    notify      => Exec["Save pm2 processes"],
			    path        => "${nodepath}:/usr/local/bin:/usr/bin:/bin",
			    require     => Exec["Reload $name nodejs application"],
			    unless      => "pm2 show $name";
		    }
		} else {
		    exec {
			"Start $name nodejs application":
			    command     => "pm2 start $startwith --name $name -i $startfork --output /var/log/nodejs/$name.log --error /var/log/nodejs/$name.err",
			    cwd         => "$installpath/$name",
			    environment => [ "PM2_HOME=$pm2home/.pm2" ],
			    notify      => Exec["Save pm2 processes"],
			    path        => "${nodepath}:/usr/local/bin:/usr/bin:/bin",
			    require     => Exec["Reload $name nodejs application"],
			    unless      => "pm2 show $name";
		    }
		}
	    }
	} else {
	    if ($nodejs::vars::service_name != "pm2") {
		file {
		    "Disable $name nodejs application":
			ensure  => absent,
			force   => true,
			notify  => Service["nodejs"],
			path    => "/etc/node/apps-enabled/$name",
			require => File["Install $name nodejs application"];
		}
	    } else {
		exec {
		    "Disable $name nodejs application":
			command     => "pm2 delete $name",
			cwd         => "/",
			environment => [ "PM2_HOME=$pm2home/.pm2" ],
			notify      => Exec["Save pm2 processes"],
			onlyif      => "pm2 show $name",
			path        => "${nodepath}:/usr/local/bin:/usr/bin:/bin",
		}
	    }
	}
    } else {
	if ($appstatus == "enabled") {
	    notify{ "can't figure out where to pull $name from": }
	}
    }
}
