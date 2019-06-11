class php::freebsd {
    $conf_dir = $php::vars::conf_dir
    $phpvers  = $php::vars::phpvers

    common::define::package {
	"php$phpvers":
    }

    file {
	"Link php.d to debian-like configuration directory":
	    ensure  => link,
	    force   => true,
	    path    => "/usr/local/etc/php",
	    target  => "$conf_dir/conf.d",
	    require => File["Prepare PHP modules enabled directory"];
	"Link php.ini to debian-like configuration":
	    ensure  => link,
	    force   => true,
	    path    => "/usr/local/etc/php.ini",
	    target  => "$conf_dir/cli/php.ini",
	    require => File["Install PHP main configuration"];
    }
}
