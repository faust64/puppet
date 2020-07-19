class nodejs::pm2service {
    if ($nodejs::vars::force_version == false) {
	$nodepath  = "/usr/local/lib/node_modules"
    } else {
	$nodepath  = "/usr/local/nodejs/lib/node_modules"
    }
    $home_dir      = $nodejs::vars::pm2_home
    $runtime_group = $nodejs::vars::pm2_group
    $runtime_user  = $nodejs::vars::pm2_user
    $sudo_conf_d   = $nodejs::vars::sudo_conf_dir

    if (($operatingsystem == "Debian" and $lsbdistcodename == "wheezy")
	or $myoperatingsystem == "Devuan"
	or ($operatingsystem == "Ubuntu" and $lsbdistcodename == "trusty")) {
	file {
	    "Install pm2 init script":
		content => template("nodejs/debian.rc.erb"),
		group   => lookup("gid_zero"),
		mode    => "0755",
		notify  => Service["pm2"],
		owner   => root,
		path    => "/etc/init.d/pm2",
		require => Nodejs::Define::Module["pm2"];
	}

	File["Install pm2 init script"]
	    -> Common::Define::Service[$nodejs::vars::service_name]

	if (defined(File["Install pm2 home directory"])) {
	    File["Install pm2 home directory"]
		-> File["Install pm2 init script"]
	}
	if (defined(Group[$runtime_group])) {
	    Group[$runtime_group]
		-> File["Install pm2 init script"]
	}
	if (defined(User[$runtime_user])) {
	    User[$runtime_user]
		-> File["Install pm2 init script"]
	}
    } elsif ($operatingsystem == "FreeBSD" or $operatingsystem == "OpenBSD") {
	file {
	    "Install pm2 rcd script":
		content => template("nodejs/rcd.erb"),
		group   => lookup("gid_zero"),
		mode    => "0755",
		notify  => Service["pm2"],
		owner   => root,
		path    => "/etc/rc.d/pm2",
		require => Nodejs::Define::Module["pm2"];
	}

	File["Install pm2 rcd script"]
	    -> Common::Define::Service[$nodejs::vars::service_name]

	if (defined(File["Install pm2 home directory"])) {
	    File["Install pm2 home directory"]
		-> File["Install pm2 rcd script"]
	}
	if (defined(Group[$runtime_group])) {
	    Group[$runtime_group]
		-> File["Install pm2 rcd script"]
	}
	if (defined(User[$runtime_user])) {
	    User[$runtime_user]
		-> File["Install pm2 rcd script"]
	}
    } else {
	if ($runtime_user == "root") {
	    exec {
		"Install pm2 systemd service":
		    command     => "pm2 startup systemd",
		    cwd         => "/",
		    environment => [ "USER=root", "PM2_HOME=/root/.pm2" ],
		    path        => "$nodepath:/usr/local/bin:/usr/bin:/bin",
		    unless      => "test -s /etc/systemd/system/pm2-root.service -o -s /lib/systemd/system/pm2.service";
	    }
	} else {
	    if (! defined(Class["sudo"])) {
		include sudo
	    }

	    file {
		"Install pm2 init sudoers":
		    content => template("nodejs/init.sudoers.erb"),
		    group   => lookup("gid_zero"),
		    mode    => "0440",
		    owner   => root,
		    path    => "$sudo_conf_d/sudoers.d/pm2-$runtime_user",
		    require => Class["sudo"];
	    }

	    if (defined(User[$nodejs::vars::pm2_user])) {
		User[$nodejs::vars::pm2_user]
		    -> File["Install pm2 init sudoers"]
	    }

	    exec {
		"Install pm2 systemd service":
		    command     => "sudo pm2 startup systemd",
		    cwd         => "/",
		    environment => [ "USER=$runtime_user", "PM2_HOME=$pm2home/.pm2" ],
		    path        => "$nodepath:/usr/local/bin:/usr/bin:/bin",
		    require     => File["Install pm2 init sudoers"],
		    unless      => "test -s /etc/systemd/system/pm2-${runtime_user}.service -o -s /lib/systemd/system/pm2.service",
		    user        => $runtime_user;
	    }
	}

	Exec["Install pm2 systemd service"]
	    -> Common::Define::Service[$nodejs::vars::service_name]
    }
}
