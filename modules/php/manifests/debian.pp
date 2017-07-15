class php::debian {
    $conf_dir = $php::vars::conf_dir

    if ($php::vars::is_fpm == true) {
	$pkgname = "php5-fpm"
    } elsif ($php::vars::is_cli == true) {
	$pkgname = "php5-cli"
    } else {
	$pkgname = "php5"
    }

    common::define::package {
	$pkgname:
    }

    if ($php::vars::with_dev) {
	common::define::package {
	    "php5-dev":
	}

	Package["php5-dev"]
	    -> Package[$pkgname]
    }
    if ($php::vars::with_apc) {
	if ($lsbdistcodename == "jessie") {
	    $apc = "php5-apcu"
	} else {
	    $apc = "php-apc"
	}

	common::define::package {
	    $apc:
	}

	Package[$apc]
	    -> Package[$pkgname]
    }

    file {
	"Install PHP cli modules loading":
	    ensure  => link,
	    force   => true,
	    path    => "$conf_dir/cli/conf.d",
	    require => File["Prepare PHP cli configuration directory"],
	    target  => "$conf_dir/conf.d";
	"Prepare PHP cgi configuration directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$conf_dir/cgi",
	    require => File["Prepare PHP for further configuration"];
	"Install PHP cgi modules loading":
	    ensure  => link,
	    force   => true,
	    path    => "$conf_dir/cgi/conf.d",
	    require => File["Prepare PHP cgi configuration directory"],
	    target  => "$conf_dir/conf.d";
    }

    exec {
	"Drop PHP cgi linked configuration":
	    command => "rm -f php.ini",
	    cwd     => "$conf_dir/cgi",
	    onlyif  => "test -h php.ini",
	    path    => "/usr/bin:/bin",
	    require => File["Install PHP cgi modules loading"];
	"Install PHP cgi configuration":
	    command => "cp -p $conf_dir/cli/php.ini php.ini",
	    cwd     => "$conf_dir/cgi",
	    path    => "/usr/bin:/bin",
	    require => Exec["Drop PHP cgi linked configuration"],
	    unless  => "cmp $conf_dir/cli/php.ini php.ini";
    }

    if ($php::vars::is_fpm == true) {
	file {
	    "Prepare PHP fpm configuration directory":
		ensure  => directory,
		group   => lookup("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "$conf_dir/fpm",
		require => File["Prepare PHP for further configuration"];
	    "Prepare PHP fpm pools configuration directory":
		ensure  => directory,
		group   => lookup("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "$conf_dir/fpm/pool.d",
		require => File["Prepare PHP fpm configuration directory"];
	    "Install PHP fpm modules loading":
		ensure  => link,
		force   => true,
		path    => "$conf_dir/fpm/conf.d",
		require => File["Prepare PHP fpm configuration directory"],
		target  => "$conf_dir/conf.d";
	}

	exec {
	    "Drop PHP fpm linked configuration":
		command => "rm -f php.ini",
		cwd     => "$conf_dir/fpm",
		onlyif  => "test -h php.ini",
		path    => "/usr/bin:/bin",
		require => File["Install PHP fpm modules loading"];
	    "Install PHP fpm configuration":
		command => "cp -p $conf_dir/cli/php.ini php.ini",
		cwd     => "$conf_dir/fpm",
		path    => "/usr/bin:/bin",
		require => Exec["Drop PHP fpm linked configuration"],
		unless  => "cmp $conf_dir/cli/php.ini php.ini";
	}

	File["Install PHP main configuration"]
	    -> Exec["Install PHP cgi configuration"]
	    -> Exec["Install PHP fpm configuration"]
    } else {
	file {
	    "Prepare PHP apache configuration directory":
		ensure  => directory,
		group   => lookup("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "$conf_dir/apache2",
		require => File["Prepare PHP for further configuration"];
	    "Install PHP apache modules loading":
		ensure  => link,
		force   => true,
		path    => "$conf_dir/apache2/conf.d",
		require => File["Prepare PHP apache configuration directory"],
		target  => "$conf_dir/conf.d";
	}

	exec {
	    "Drop PHP apache linked configuration":
		command => "rm -f php.ini",
		cwd     => "$conf_dir/apache2",
		onlyif  => "test -h php.ini",
		path    => "/usr/bin:/bin",
		require => File["Install PHP cgi modules loading"];
	    "Install PHP apache configuration":
		command => "cp -p $conf_dir/cli/php.ini php.ini",
		cwd     => "$conf_dir/apache2",
		path    => "/usr/bin:/bin",
		require => Exec["Drop PHP apache linked configuration"],
		unless  => "cmp $conf_dir/cli/php.ini php.ini";
	}

	File["Install PHP main configuration"]
	    -> Exec["Install PHP cgi configuration"]
	    -> Exec["Install PHP apache configuration"]
    }

    Package[$pkgname]
	-> File["Prepare PHP for further configuration"]
}
