class git::gitlist {
    if (! defined(Class["apache"])) {
	include apache
    }

    $repo_root = $git::vars::repo_root
    $rdomain   = $git::vars::rdomain
    $version   = $git::vars::gitlist_vers
    $web_root  = $apache::vars::web_root

    if ($domain != $rdomain) {
	$reverse = "gitlist.$rdomain"
	if ($git::vars::with_gitlab == true) {
	    $aliases = [ $reverse ]
	} else {
	    $aliases = [ "git.$domain", "git.$rdomain", $reverse ]
	}
    } else {
	$reverse = false
	if ($git::vars::with_gitlab == true) {
	    $aliases = [ "git.$domain" ]
	} else {
	    $aliases = false
	}
    }

    file {
	"Prepare git repository root":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $repo_root;
	"Install GitList main configuration":
	    content => template("git/gitlist.erb"),
	    group   => $apache::vars::runtime_group,
	    mode    => "0640",
	    owner   => root,
	    path    => "$web_root/gitlist/config.ini",
	    require => Exec["Extract gitlist server root"];
	"Set application cache permissions":
	    ensure  => directory,
	    group   => $apache::vars::runtime_group,
	    mode    => "0771",
	    owner   => $apache::vars::runtime_user,
	    path    => "$web_root/gitlist/cache",
	    require => File["Install GitList main configuration"];
    }

    common::define::geturl {
	"gitlist":
	    nomv    => true,
	    notify  => Exec["Extract gitlist server root"],
	    require => File["Prepare www directory"],
	    target  => "/root/gitlist-$version.tar.gz",
	    url     => "https://s3.amazonaws.com/gitlist/gitlist-$version.tar.gz",
	    wd      => "/root";
    }

    exec {
	"Extract gitlist server root":
	    command     => "tar -xzf /root/gitlist-$version.tar.gz",
	    cwd         => $web_root,
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
    }

    apache::define::vhost {
	"gitlist.$domain":
	    aliases        => $aliases,
	    allow_override => "All",
	    options        => "-Indexes",
	    require        => File["Set application cache permissions"],
	    vhostldapauth  => false,
	    with_reverse   => $reverse;
    }
}
