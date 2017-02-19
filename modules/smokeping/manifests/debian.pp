class smokeping::debian {
    $share_dir = $smokeping::vars::share_dir
    $web_root  = $smokeping::vars::web_root

    common::define::package {
	"smokeping":
    }

    file {
	"Link smokeping share directory to apache server root":
	    ensure  => link,
	    force   => true,
	    path    => "$web_root/smokeping",
	    require => Package["smokeping"],
	    target  => "$share_dir/www";
    }

    if (defined(Class["nginx"])) {
#	common::define::package {
#	    [ "apache2", "apache2.2-bin", "apache2.2-common", "apache2-mpm-worker", "apache2-utils" ]:
#		ensure  => purged,
#		require => Package["smokeping"];
#	}

	file {
	    "Link smokeping.cgi to served directory":
		ensure  => link,
		force   => true,
		require => File["Link smokeping share directory to apache server root"],
		path    => "$web_root/smokeping/smokeping.cgi",
		target => "/usr/lib/cgi-bin/smokeping.cgi";
	}

	Class[Nginx]
	    -> File["Link smokeping share directory to apache server root"]
	    -> File["Link smokeping.cgi to served directory"]
    } else {
	Class[Apache]
	    -> File["Link smokeping share directory to apache server root"]
    }

    Package["smokeping"]
	-> Service["smokeping"]
}
