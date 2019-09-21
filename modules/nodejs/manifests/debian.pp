class nodejs::debian {
    $version = $nodejs::vars::force_version

    if ($version == false) {
	if ($lsbdistcodename == "wheezy") {
	    if (! defined(Apt::Define::Repo["backports"])) {
		apt::define::repo {
		    "backports":
			branches => "main contrib non-free",
			codename => "wheezy-backports";
		}
	    }

	    Apt::Define::Repo["backports"]
		-> Common::Define::Package["nodejs"]
	}
	if ($lsbdistcodename != "stretch" and $lsbdistcodename != "buster") {
	    common::define::package {
		"npm":
		    require =>
			[
			    Common::Define::Package["nodejs"],
			    File["NPM needs node binary"]
			];
	    }

	    if ($nodejs::vars::service_name == "nodejs") {
		Common::Define::Package["npm"]
		    -> File["Install Node.JS service init script"]
		    -> Common::Define::Service[$nodejs::vars::service_name]
	    } elsif ($nodejs::vars::service_name == "pm2") {
		Common::Define::Package["npm"]
		    -> Nodejs::Define::Module["pm2"]
		    -> Common::Define::Service[$nodejs::vars::service_name]
	    }

	    file {
		"NPM needs node binary":
		    ensure  => link,
		    path    => "/usr/bin/node",
		    target  => "/usr/bin/nodejs";
	    }

	    Common::Define::Package["nodejs"]
		-> File["NPM needs node binary"]
	} else {
#FIXME: stretch has no npm package, nor binary out of nodejs one?
	    if ($nodejs::vars::service_name == "nodejs") {
		Common::Define::Package["nodejs"]
		    -> File["Install Node.JS service init script"]
		    -> Common::Define::Service[$nodejs::vars::service_name]
	    } elsif ($nodejs::vars::service_name == "pm2") {
		Common::Define::Package["nodejs"]
		    -> Nodejs::Define::Module["pm2"]
		    -> Common::Define::Service[$nodejs::vars::service_name]
	    }
	}

	common::define::package {
	    "nodejs":
	}
    } elsif ($nodejs::vars::from_sources) {
	exec {
	    "Fetch nodejs":
		command     => "rm -f node-v$version.tar.gz ; wget https://nodejs.org/dist/v$version/node-v$version.tar.gz",
		cwd         => "/root",
		unless      => "tar -tzf node-v$version.tar.gz >/dev/null",
		notify      => Exec["Extract nodejs"],
		path        => "/usr/bin:/bin";
	    "Extract nodejs":
		command     => "tar -xzf /root/node-v$version.tar.gz",
		cwd         => "/usr/src",
		notify      => Exec["Configure nodejs"],
		path        => "/usr/bin:/bin",
		refreshonly => true;
	    "Configure nodejs":
		command     => "configure",
		cwd         => "/usr/src/node-v$version",
		notify      => Exec["Build nodejs"],
		path        => "/usr/bin:/bin:/usr/src/node-v$version",
		refreshonly => true,
		require     => Class[Common::Tools::Make];
	    "Build nodejs":
		command     => "make",
		cwd         => "/usr/src/node-v$version",
		notify      => Exec["Install nodejs"],
		path        => "/usr/bin:/bin",
		refreshonly => true,
		timeout     => 3600;
	    "Install nodejs":
		command     => "make install",
		cwd         => "/usr/src/node-v$version",
		path        => "/usr/bin:/bin",
		refreshonly => true;
	}

	if ($nodejs::vars::service_name == "nodejs") {
	    Exec["Install nodejs"]
		-> File["Install Node.JS service init script"]
	} elsif ($nodejs::vars::service_name == "pm2") {
	    Exec["Install nodejs"]
		-> Nodejs::Define::Module["pm2"]
	}
    } else {
	$archi = $architecture ?  {
	    "amd64"  => "x64",
	    "x86_64" => "x64",
	    default  => "x32"
	}

	if ($nodeversion != "" and $nodeversion != "v$version") {
	    exec {
		"Backup previous nodejs install":
		    command     => "mv nodejs node-$nodeversion-linux-$archi",
		    cwd         => "/usr/local",
		    path        => "/usr/bin:/bin";
	    }

	    Exec["Backup previous nodejs install"]
		-> Exec["Extract nodejs"]
	}

	exec {
	    "Fetch nodejs":
		command     => "rm -f node-v$version-linux-$archi.tar.xz ; wget https://nodejs.org/dist/v$version/node-v$version-linux-$archi.tar.xz",
		cwd         => "/root",
		unless      => "tar -tJf node-v$version-linux-$archi.tar.xz >/dev/null",
		notify      => Exec["Extract nodejs"],
		path        => "/usr/bin:/bin";
	    "Extract nodejs":
		command     => "tar -xJf /root/node-v$version-linux-$archi.tar.xz && mv node-v$version-linux-$archi nodejs",
		cwd         => "/usr/local",
		path        => "/usr/bin:/bin",
		refreshonly => true;
	}

	file {
	    "Link node binary into our PATH":
		ensure => link,
		force   => true,
		path    => "/usr/bin/node",
		require => Exec["Extract nodejs"],
		target  => "/usr/local/nodejs/bin/node";
	    "Link npm binary into our PATH":
		ensure => link,
		force   => true,
		path    => "/usr/bin/npm",
		require => Exec["Extract nodejs"],
		target  => "/usr/local/nodejs/bin/npm";
	}

	if ($nodejs::vars::service_name == "nodejs") {
	    File["Link node binary into our PATH"]
		-> File["Link npm binary into our PATH"]
		-> File["Install Node.JS service init script"]
	} elsif ($nodejs::vars::service_name == "pm2") {
	    File["Link node binary into our PATH"]
		-> File["Link npm binary into our PATH"]
		-> Nodejs::Define::Module["pm2"]
	}
    }
}
