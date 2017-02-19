class munin::webapp {
    include apache

    $conf_dir = $apache::vars::conf_dir
    $rdomain  = $munin::vars::rdomain
    $web_root = $munin::vars::web_root

    if ($domain != $rdomain) {
	$reverse = "munin.$rdomain"
	$aliases = [ $reverse ]
    } else {
	$reverse = false
	$aliases = false
    }

    file {
	"Remove munin default apache configuration":
	    ensure  => absent,
	    force   => true,
	    notify  => Service[$apache::vars::service_name],
	    path    => "$conf_dir/conf.d/munin",
	    require =>
		[
		    File["Prepare Munin for further configuration"],
		    Class["apache"]
		];
    }

    apache::define::vhost {
	"munin.$domain":
	    aliases       => $aliases,
	    app_root      => "$web_root/munin",
	    csp_name      => "munin",
	    options       => "FollowSymLinks MultiViews",
	    preserve_host => "Off",
	    vhostldapauth => "none",
	    vhostsource   => "munin",
	    with_reverse  => $reverse;
    }
}
