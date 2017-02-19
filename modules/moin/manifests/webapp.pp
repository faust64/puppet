class moin::webapp {
    include apache

    $rdomain = $moin::vars::rdomain
    $web_dir = $moin::vars::web_dir
    if ($domain != $rdomain) {
	$reverse = "wiki.$rdomain"
	$aliases = [ $reverse ]
    } else {
	$reverse = false
	$aliases = false
    }

    file {
	"Prepare MoinMoin web root":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $web_dir;
    }

    if ($moin::vars::apache_vers == "2.2") {
	file {
	    "Prepare MoinMoin cgi directory":
		ensure  => directory,
		group   => hiera("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "$web_dir/wiki",
		require => File["Prepare MoinMoin web root"];
	    "Link MoinMoin cgi":
		ensure  => link,
		force   => true,
		path    => "$web_dir/wiki/moin.cgi",
		require => File["Prepare MoinMoin cgi directory"],
		target  => "/usr/share/moin/server/moin.cgi";
	}

	File["Link MoinMoin cgi"]
	    -> Apache::Define::Vhost["wiki.$domain"]
    } else {
	file {
	    "Prepare MoinMoin wsgi directory":
		ensure  => directory,
		group   => hiera("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "$web_dir/wiki",
		require => File["Prepare MoinMoin web root"];
	    "Link MoinMoin wsgi":
		ensure  => link,
		force   => true,
		path    => "$web_dir/wiki/moin.wsgi",
		require => File["Prepare MoinMoin wsgi directory"],
		target  => "/usr/share/moin/server/moin.wsgi";
	}

	File["Link MoinMoin wsgi"]
	    -> Apache::Define::Vhost["wiki.$domain"]
    }

    apache::define::vhost {
	"wiki.$domain":
	    aliases       => $aliases,
	    app_root      => $web_dir,
	    csp_name      => "moinmoin",
	    vhostldapauth => true,
	    vhostsource   => "moin",
	    with_reverse  => $reverse;
    }
}
