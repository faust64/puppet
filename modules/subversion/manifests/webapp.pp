class subversion::webapp {
    if (! defined(Class["apache"])) {
	include apache
    }

    $conf_dir     = $subversion::vars::apache_conf_dir
    $rdomain      = $subversion::vars::rdomain
    $web_root     = $subversion::vars::web_root

    if ($domain != $rdomain) {
	$reverse = "sources.$rdomain"
	$aliases = [ $reverse, "svn.$domain", "svn.$rdomain", "websvn.$domain", "websvn.$rdomain" ]
    } else {
	$reverse = false
	$aliases = [ "svn.$domain", "svn.$rdomain", "websvn.$domain", "websvn.$rdomain" ]
    }

    file {
	"Link web root websvn to site data":
	    ensure  => link,
	    force   => true,
	    path    => "$web_root/websvn",
	    target  => "/usr/share/websvn",
	    require => File["Prepare www directory"];

	"Install subversion repositories root":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/home/svn";
	"Install subversion default access file":
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/home/svn/access",
	    require => File["Install subversion repositories root"],
	    source  => "puppet:///modules/subversion/access";
	"Install subversion RO user htaccess":
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/home/svn/htpasswd",
	    require => File["Install subversion repositories root"],
	    source  => "puppet:///modules/subversion/htpasswd";
    }

    apache::define::vhost {
	"sources.$domain":
	    aliases       => [ "sources.$rdomain", "svn.$domain", "svn.$rdomain", "websvn.$domain", "websvn.$rdomain" ],
	    vhostldapauth => true,
	    vhostsource   => "subversion",
	    with_reverse  => "sources.$rdomain";
    }
}
