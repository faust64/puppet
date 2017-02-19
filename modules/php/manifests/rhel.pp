class php::rhel {
    $conf_dir = $php::vars::conf_dir

    if ($php::vars::is_fpm == true) {
	$pkgname = "php-fpm"
    } elsif ($php::vars::is_cli == true) {
	$pkgname = "php-cli"
    } else {
	$pkgname = "php"
    }

    common::define::package {
	$pkgname:
    }

    if ($php::vars::with_dev) {
	common::define::package {
	    "php-dev":
	}

	Package["php-dev"]
	    -> Package[$pkgname]
    }
    if ($php::vars::with_apc) {
	common::define::package {
	    "php-pecl-apc":
	}

	Package["php-pecl-apc"]
	    -> Package[$pkgname]
    }

    file {
	"Link php.d to debian-like configuration directory":
	    ensure  => link,
	    force   => true,
	    path    => "/etc/php.d",
	    target  => "$conf_dir/conf.d",
	    require => File["Prepare PHP modules enabled directory"];
	"Link php.ini to debian-like configuration":
	    ensure  => link,
	    force   => true,
	    path    => "/etc/php.ini",
	    target  => "$conf_dir/cli/php.ini",
	    require => File["Install PHP main configuration"];
    }

    if ($php::vars::is_fpm == true) {
	file {
	    "Prepare PHP fpm configuration directory":
		ensure  => directory,
		group   => hiera("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "$conf_dir/fpm",
		require => File["Link php.d to debian-like configuration directory"];
	    "Prepare PHP fpm pools configuration directory":
		ensure  => directory
		group   => hiera("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "$conf_dir/fpm/pool.d",
		require => File["Prepare PHP fpm configuration directory"];
	}
    }

    Package[$pkgname]
	-> File["Prepare PHP for further configuration"]
}
