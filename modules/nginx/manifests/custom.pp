class nginx::custom {
    $conf_dir        = $nginx::vars::conf_dir
    $error_dir       = $nginx::vars::error_dir
    $robots_allow    = $nginx::vars::robots_allow
    $robots_disallow = $nginx::vars::robots_disallow
    $repo            = $nginx::vars::repo
    $web_root        = $nginx::vars::web_root

    file {
	"Install Nginx error messages":
	    group   => lookup("gid_zero"),
	    ignore  => [ ".svn", ".git" ],
	    owner   => root,
	    path    => $error_dir,
	    recurse => true,
	    require => File["Prepare Nginx for further configuration"],
	    source  => "puppet:///modules/nginx/error";
	"Install robots.txt (nginx)":
	    content => template("apache/robots.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$web_root/robots.txt",
	    require => File["Prepare www directory"];
	"Install Nginx error configuration":
	    content => template("nginx/errors.erb"),
	    mode    => "0644",
	    notify  => Service["nginx"],
	    owner   => root,
	    path    => "$conf_dir/errors.conf",
	    require => File["Prepare Nginx for further configuration"];
    }

    common::define::geturl {
	"Nginx error background":
	    nomv    => true,
	    require => File["Install Nginx error messages"],
	    target  => "$error_dir/webserver-background.jpg",
	    url     => "$repo/puppet/webserver-background.jpg",
	    wd      => $error_dir;
    }
}
