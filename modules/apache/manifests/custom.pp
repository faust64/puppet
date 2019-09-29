class apache::custom {
    $download        = $apache::vars::download
    $error_dir       = $apache::vars::error_dir
    $repo            = $apache::vars::repo
    $robots_allow    = $apache::vars::robots_allow
    $robots_disallow = $apache::vars::robots_disallow
    $version         = $apache::vars::version
    $web_root        = $apache::vars::web_root

    file {
	"Install Apache error messages":
	    group   => lookup("gid_zero"),
	    ignore  => [ ".svn", ".git" ],
	    owner   => root,
	    path    => $error_dir,
	    recurse => true,
	    require => File["Prepare Apache for further configuration"],
	    source  => "puppet:///modules/apache/error$version";
	"Link Apache error includes":
	    ensure  => link,
	    force   => true,
	    path    => "$web_root/include",
	    target  => "$error_dir/include";
	"Install robots.txt (apache)":
	    content => template("apache/robots.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$web_root/robots.txt",
	    require => File["Prepare www directory"];
    }

    exec {
	"Install Apache error background":
	    command => "$download $repo/puppet/webserver-background.jpg",
	    cwd     => "$error_dir/include",
	    path    => "/usr/bin:/bin",
	    require => File["Install Apache error messages"],
	    unless  => "test -s webserver-background.jpg";
    }

    if ($download == "wget") {
	Common::Define::Package["wget"]
	    -> Exec["Install Apache error background"]
    }
}
