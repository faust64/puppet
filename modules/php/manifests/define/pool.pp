define php::define::pool($ensure        = "present",
			 $listen_group  = hiera("apache_runtime_group"),
			 $listen_user   = hiera("apache_runtime_user"),
			 $poolrsyslog   = false,
			 $root_dir      = "/",
			 $runtime_group = hiera("apache_runtime_group"),
			 $runtime_user  = hiera("apache_runtime_user"),
			 $socket        = "/var/run/php5-fpm.$name.sock") {
    $conf_dir         = $php::vars::conf_dir
    $rsyslog_conf_dir = $php::vars::rsyslog_conf_dir
    $rsyslog_version  = $php::vars::rsyslog_version

    if ($ensure == "present") {
	if (! defined(File["Install php-fpm log directory"])) {
	    file {
		"Install php-fpm log directory":
		    ensure => directory,
		    group  => hiera("gid_zero"),
		    mode   => "0755",
		    owner  => root,
		    path   => "/var/log/php-fpm";
	    }
	}

	file {
	    "Prepare $name fpm pool access log file":
		ensure  => present,
		group   => $runtime_group,
		mode    => "0640",
		owner   => $runtime_user,
		path    => "/var/log/php-fpm/$name.access.log",
		require => File["Install php-fpm log directory"];
	    "Prepare $name fpm pool slow log file":
		ensure  => present,
		group   => $runtime_group,
		mode    => "0640",
		owner   => $runtime_user,
		path    => "/var/log/php-fpm/$name.slow.log",
		require => File["Install php-fpm log directory"];
	    "Install $name fpm pool":
		content => template("php/pool.erb"),
		group   => hiera("gid_zero"),
		mode    => "0644",
		notify  => Service[$php::vars::srvname],
		owner   => root,
		path    => "$conf_dir/fpm/pool.d/$name.conf",
		require =>
		    [
			File["Prepare $name fpm pool access log file"],
			File["Prepare $name fpm pool slow log file"],
			File["Prepare PHP fpm pools configuration directory"]
		    ];
	}

	if ($poolrsyslog == true) {
	    file {
		"Enable php-fpm pool $name rsyslog configuration":
		    content => template("php/rsyslog.erb"),
		    group   => hiera("gid_zero"),
		    mode    => "0600",
		    notify  => Service[$php::vars::rsyslog_service_name],
		    owner   => root,
		    path    => "$rsyslog_conf_dir/rsyslog.d/13_fpm_pool_$name.conf",
		    require => File["Prepare rsyslog for further configuration"];
	    }
	}
    } elsif (defined(Service[$php::vars::srvname])) {
	file {
	    "Drop $name fpm pool":
		ensure  => "absent",
		force   => true,
		notify  => Service[$php::vars::srvname],
		path    => "$conf_dir/fpm/pool.d/$name.conf",
		require => File["Prepare PHP fpm pools configuration directory"];
	}
    } else {
	file {
	    "Drop $name fpm pool":
		ensure  => "absent",
		force   => true,
		path    => "$conf_dir/fpm/pool.d/$name.conf";
	}
    }

    if (! defined(File["Enable php-fpm pool $name rsyslog configuration"])) {
	if (defined(Service[$php::vars::rsyslog_service_name])) {
	    file {
		"Drop php-fpm pool $name rsyslog configuration":
		    ensure  => "absent",
		    force   => true,
		    notify  => Service[$php::vars::rsyslog_service_name],
		    path    => "$rsyslog_conf_dir/rsyslog.d/13_fpm_pool_$name.conf",
		    require => File["Prepare rsyslog for further configuration"];
	    }
	} else {
	    file {
		"Drop php-fpm pool $name rsyslog configuration":
		    ensure  => "absent",
		    force   => true,
		    path    => "$rsyslog_conf_dir/rsyslog.d/13_fpm_pool_$name.conf";
	    }
	}
    }
}
